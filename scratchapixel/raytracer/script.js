// http://www.scratchapixel.com/code.php?id=3&origin=/lessons/3d-basic-rendering/introduction-to-ray-tracing
+function() {

function Vec3(x, y, z) {
  this.x = x;
  this.y = y;
  this.z = z;
}

Vec3.prototype.length2 = function length2() {
  return this.x * this.x + this.y + this.y + this.z * this.z;
}


Vec3.prototype.length = function length() {
  return Math.sqrt(this.length2());
}

Vec3.prototype.dot = function dot(v) {
  return this.x * v.x + this.y * v.y + this.z * v.z;
}

Vec3.prototype.normalize = function normalize() {
  var len = this.length2();
  if (len > 0) {
    var invLen = 1 / Math.sqrt(len);
    this.x *= invLen, this.y *= invLen, this.z *= invLen;
  }

  return this;
}

Vec3.prototype.cross = function cross(v) {
  return new Vec3(
    this.y * v.z - this.z * v.y,
    this.z * v.x - this.x * v.z,
    this.x * v.y - this.y * v.x);
}

Vec3.prototype.sum = function sum(v) {
  return new Vec3(this.x + v.x, this.y + v.y, this.z + v.z);
}

Vec3.prototype.neg = function neg(v) {
  return new Vec3(-this.x, -this.y, -this.z);
}

Vec3.prototype.sub = function sub(v) {
  return new Vec3(this.x - v.x, this.y - v.y, this.z - v.z);
}

Vec3.prototype.mult = function mult() {
  if (typeof arguments[0] == 'number') {
    var r = arguments[0];
    return new Vec3(this.x * r, this.y * r, this.z * r);
  }
  else {
    var v = arguments[0];
    return new Vec3(this.x * v.x, this.y * v.y, this.z * v.z);
  }
}



function Sphere(center, radius, surfaceColor, reflection, transparency, emissionColor) {
  this.center = center;
  this.radius = radius;
  this.radius2 = radius * radius;
  this.surfaceColor = surfaceColor;
  this.emissionColor = emissionColor ? emissionColor : new Vec3(0, 0, 0);
  this.transparency = transparency;
  this.reflection = reflection;
}

Sphere.prototype.intersect = function intersect(rayorig, raydir) {
  var l = this.center.sub(rayorig);
  var tca = l.dot(raydir);
  if (tca < 0) return [false];

  var d2 = l.dot(l) - tca * tca;
  if (d2 > this.radius2) return [false];

  var thc = sqrt(this.radius2 - d2);
  return [true, tca - thc, tca + thc];
}




var MAX_RAY_DEPTH = 5;
var INFINITY = 10e8;
var M_PI = 3.141592653589793
var sqrt = Math.sqrt;
var pow = Math.pow;


function mix(a, b, mix) {
  return b * mix + a * (1 - mix);
}



function trace(rayorig, raydir, spheres, depth) {
  var tnear = INFINITY;
  var sphere = false;

  // find intersection of this ray with the sphere in the scene
  for (var i in spheres) {
    var t0 = INFINITY, t1 = INFINITY;
    var intersection = spheres[i].intersect(rayorig, raydir);
    if(intersection[0]) {
      t0 = intersection[1], t1 = intersection[2];
      if(t0 < tnear) {
        tnear = t0;
        sphere = spheres[i];
      }
    }
  }

  // if there's no intersection return black or background color
  if (sphere == false) return new Vec3(1, 1, 1);

  var surfaceColor = new Vec3(0, 0, 0);
  var phit = rayorig.sum(raydir.mult(tnear));
  var nhit = phit.sub(sphere.center);
  nhit.normalize();
  // If the normal and the view direction are not opposite to each other
  // reverse the normal direction. That also means we are inside the sphere so set
  // the inside bool to true. Finally reverse the sign of IdotN which we want
  // positive.
  var bias = 1e-4;
  var inside = false;
  if (raydir.dot(nhit) > 0) {
    nhit = nhit.neg();
    inside = true;
  }

  if ((sphere.transparency > 0 || sphere.reflection > 0) && depth < MAX_RAY_DEPTH) {
    var facingratio = raydir.neg().dot(nhit);
    // change the mix value to tweak the effect
    var fresneleffect = mix(pow(1 - facingratio, 3), 1, 0.1);
    // compute reflection direction (not need to normalize because all vectors
    // are already normalized)
    var refldir = raydir.mult(raydir.dot(nhit)).mult(2).sub(nhit);
    refldir.normalize();
    var reflection = trace(phit.sum(nhit.mult(bias)), refldir, spheres, depth + 1);
    var refraction = new Vec3(0, 0, 0);
    // if the sphere is also transparent compute refraction ray (transmission)
    if (sphere.transparency) {
      var ior = 1.1, eta = (inside) ? ior : 1 / ior; // are we inside or outside the surface?
      var cosi = -nhit.dot(raydir);
      var k = 1 - eta * eta * (1 - cosi * cosi);
      var refrdir = raydir.mult(eta).sum(nhit.mult(eta *  cosi - sqrt(k)));
      refrdir.normalize();
      refraction = trace(phit.sub(nhit.mult(bias)), refrdir, spheres, depth + 1);
    }
    // the result is a mix of reflection and refraction (if the sphere is transparent)
    surfaceColor = sphere.surfaceColor.mult(
      reflection.mult(fresneleffect).sum(
        refraction.mult((1 - fresneleffect) * sphere.transparency)
      )
    );

  }
  else {
    // it's a diffuse object, no need to raytrace any further
    for (var i in spheres) {
      if (spheres[i].emissionColor.x > 0) {
        // this is a light
        var transmission = new Vec3(1, 1, 1);
        var lightDirection = spheres[i].center.sub(phit);
        lightDirection.normalize();
        for (var j in spheres) {
          if (i != j) {
            var intersection = spheres[j].intersect(phit.sum(nhit.mult(bias)), lightDirection);
            if(intersection[0]) {
              transmission = new Vec3(0, 0, 0);
              break;
            }
          }
        }
        surfaceColor = surfaceColor.sum(
          sphere.surfaceColor
          .mult(transmission)
          .mult(Math.max(0, nhit.dot(lightDirection)))
          .mult(spheres[i].emissionColor)
        );
      }
    }
  }

  return surfaceColor.sum(sphere.emissionColor);
}



function render(spheres, w, h) {
    var pixels = [];
    var invWidth = 1 / w, invHeight = 1 / h;
    var fov = 30, aspectratio = w / h;
    var angle = Math.tan(M_PI * 0.5 * fov / 180);
    // Trace rays
    for (var y = 0; y < h; ++y) {
        for (var x = 0; x < w; ++x) {
            var xx = (2 * ((x + 0.5) * invWidth) - 1) * angle * aspectratio;
            var yy = (1 - 2 * ((y + 0.5) * invHeight)) * angle;
            var raydir = new Vec3(xx, yy, -1);
            raydir.normalize();
            pixels.push(trace(new Vec3(0, 0, 0), raydir, spheres, 0));
        }
    }
    return pixels;
}


var spheres = [];
// position, radius, surface color, reflectivity, transparency, emission color
spheres.push(new Sphere(new Vec3( 0.0, -10004, -20), 10000, new Vec3(0.20, 0.20, 0.20), 0, 0.0));
spheres.push(new Sphere(new Vec3( 0.0,      0, -20),     4, new Vec3(1.00, 0.32, 0.36), 1, 0.5));
spheres.push(new Sphere(new Vec3( 5.0,     -1, -15),     2, new Vec3(0.90, 0.76, 0.46), 1, 0.0));
spheres.push(new Sphere(new Vec3( 5.0,      0, -25),     3, new Vec3(0.65, 0.77, 0.97), 1, 0.0));
spheres.push(new Sphere(new Vec3(-5.5,      0, -15),     3, new Vec3(0.90, 0.90, 0.90), 1, 0.0));
// light
spheres.push(new Sphere(new Vec3( 0.0,     20, -30),     3, new Vec3(0.00, 0.00, 0.00), 0, 0.0, new Vec3(3, 3, 3)));

var w = 340, h = 280;
var context2d = document.getElementById('canvas').getContext('2d');
var imageData = context2d.getImageData(0, 0, w, h);
var rawData = imageData.data;
var pixel, index = 0;

var pixels = render(spheres, w, h);

for (var i in pixels) {
  pixel = pixels[i];

  rawData[index++] = ~~(pixel.x * 255);
  rawData[index++] = ~~(pixel.y * 255);
  rawData[index++] = ~~(pixel.z * 255);
  rawData[index++] = 255;
}

context2d.putImageData(imageData, 0, 0);

window.pixels = pixels;

}();