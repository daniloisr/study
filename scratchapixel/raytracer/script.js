// http://www.scratchapixel.com/code.php?id=3&origin=/lessons/3d-basic-rendering/introduction-to-ray-tracing
+function() {

var sqrt = Math.sqrt;

function Vec3(x, y, z) {
  this.x = x;
  this.y = y;
  this.z = z;
}

Vec3.prototype.length = function length() {
  return Math.sqrt(this.x * this.x + this.y + this.y + this.z * this.z);
}

Vec3.prototype.dot = function dot(v) {
  return this.x * v.x + this.y * v.y + this.z * v.z;
}

Vec3.prototype.normalize = function normalize() {
  var len = this.length();
  if (len > 0) {
    var invLen = 1 / len;
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

Vec3.prototype.add = function add(v) {
  return new Vec3(this.x + v.x + this.y + v.y + this.z + v.z);
}

Vec3.prototype.sub = function sub(v) {
  return new Vec3(this.x - v.x + this.y - v.y + this.z - v.z);
}

Vec3.prototype.mult = function mult(r) {
  return new Vec3(this.x * r + this.y * r + this.z * r);
}




function Sphere(center, radius, surfaceColor, emissionColor, transparency, reflection) {
  this.center = center;
  this.radius = radius;
  this.radius2 = radius * radius;
  this.surfaceColor = surfaceColor;
  this.emissionColor = emissionColor;
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

  //     float tca = l.dot(raydir);
  //     if (tca < 0) return false;
  //     float d2 = l.dot(l) - tca * tca;
  //     if (d2 > radius2) return false;
  //     float thc = sqrt(radius2 - d2);
  //     t0 = tca - thc;
  //     t1 = tca + thc;

  //     return true;

}




var MAX_RAY_DEPTH = 5;
var INFINITY = 10e8;
var M_PI = 3.141592653589793

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
        sphere = sphere[i];
      }
    }
  }

  // if there's no intersection return black or background color
  if (sphere == false) return new Vec3(2, 2, 2);

  var surfaceColor = new Vec3(0, 0, 0);
//     Vec3f phit = rayorig + raydir * tnear; // point of intersection
//     Vec3f nhit = phit - sphere->center; // normal at the intersection point
//     nhit.normalize(); // normalize normal direction
//     // If the normal and the view direction are not opposite to each other
//     // reverse the normal direction. That also means we are inside the sphere so set
//     // the inside bool to true. Finally reverse the sign of IdotN which we want
//     // positive.
//     float bias = 1e-4; // add some bias to the point from which we will be tracing
//     bool inside = false;
//     if (raydir.dot(nhit) > 0) nhit = -nhit, inside = true;
//     if ((sphere->transparency > 0 || sphere->reflection > 0) && depth < MAX_RAY_DEPTH) {
//         float facingratio = -raydir.dot(nhit);
//         // change the mix value to tweak the effect
//         float fresneleffect = mix(pow(1 - facingratio, 3), 1, 0.1);
//         // compute reflection direction (not need to normalize because all vectors
//         // are already normalized)
//         Vec3f refldir = raydir - nhit * 2 * raydir.dot(nhit);
//         refldir.normalize();
//         Vec3f reflection = trace(phit + nhit * bias, refldir, spheres, depth + 1);
//         Vec3f refraction = 0;
//         // if the sphere is also transparent compute refraction ray (transmission)
//         if (sphere->transparency) {
//             float ior = 1.1, eta = (inside) ? ior : 1 / ior; // are we inside or outside the surface?
//             float cosi = -nhit.dot(raydir);
//             float k = 1 - eta * eta * (1 - cosi * cosi);
//             Vec3f refrdir = raydir * eta + nhit * (eta *  cosi - sqrt(k));
//             refrdir.normalize();
//             refraction = trace(phit - nhit * bias, refrdir, spheres, depth + 1);
//         }
//         // the result is a mix of reflection and refraction (if the sphere is transparent)
//         surfaceColor = (
//             reflection * fresneleffect +
//             refraction * (1 - fresneleffect) * sphere->transparency) * sphere->surfaceColor;
//     }
//     else {
//         // it's a diffuse object, no need to raytrace any further
//         for (unsigned i = 0; i < spheres.size(); ++i) {
//             if (spheres[i].emissionColor.x > 0) {
//                 // this is a light
//                 Vec3f transmission = 1;
//                 Vec3f lightDirection = spheres[i].center - phit;
//                 lightDirection.normalize();
//                 for (unsigned j = 0; j < spheres.size(); ++j) {
//                     if (i != j) {
//                         float t0, t1;
//                         if (spheres[j].intersect(phit + nhit * bias, lightDirection, t0, t1)) {
//                             transmission = 0;
//                             break;
//                         }
//                     }
//                 }
//                 surfaceColor += sphere->surfaceColor * transmission *
//                 std::max(float(0), nhit.dot(lightDirection)) * spheres[i].emissionColor;
//             }
//         }
//     }

//     return surfaceColor + sphere->emissionColor;
// }

}();