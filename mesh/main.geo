//Inputs
fan_outlet_radius = 0.1; // m
fan_outlet_height = 0.02; // m
curve_radius = 0.25; // m
domain_radius = 10; // m

fan_lc = 0.002;
domain_lc = 0.03 * domain_radius;

ce = 0;

// Aerodynamic surface.
first_point = ce;
Point(ce++) = {0, 0, 0, fan_lc};
Point(ce++) = {fan_outlet_radius, 0, 0, fan_lc};

loop_lines = {};
loop_lines += ce;
Line(ce++) = {ce - 3, ce - 2};

Point(ce++) = {fan_outlet_radius, -fan_outlet_height, 0, fan_lc};

loop_lines += ce;
Line(ce++) = {ce - 4, ce - 2};

Point(ce++) = {fan_outlet_radius, -fan_outlet_height - curve_radius, 0, fan_lc};
Point(ce++) = {fan_outlet_radius + curve_radius
    , -fan_outlet_height - curve_radius
    , 0, fan_lc};

loop_lines += ce;
Circle(ce++) = {ce - 5, ce - 3, ce - 2};

Point(ce++) = {fan_outlet_radius, -fan_outlet_height - 2 * curve_radius, 0, fan_lc};

loop_lines += ce;
Circle(ce++) = {ce - 4, ce - 5, ce - 2};

Point(ce++) = {0, -fan_outlet_height - 2 * curve_radius, 0, fan_lc};

loop_lines += ce;
Line(ce++) = {ce - 4, ce - 2};

// Domain.
Point(ce++) = {0, -domain_radius, 0, domain_lc};

loop_lines += ce;
Line(ce++) = {ce - 4, ce - 2};

Point(ce++) = {domain_radius, -domain_radius, 0, domain_lc};

loop_lines += ce;
Line(ce++) = {ce - 4, ce - 2};

Point(ce++) = {domain_radius, domain_radius, 0, domain_lc};

loop_lines += ce;
Line(ce++) = {ce - 4, ce - 2};

Point(ce++) = {0, domain_radius, 0, domain_lc};

loop_lines += ce;
Line(ce++) = {ce - 4, ce - 2};

loop_lines += ce;
Line(ce++) = {ce - 3, first_point};

line_loop = ce;
Line Loop(ce++) = loop_lines[];
surface = ce;
Plane Surface(ce++) = line_loop;

wedgeAngle = 5 * Pi / 180;
Rotate {{0, 1, 0}, {0, 0, 0}, wedgeAngle / 2}
{
    Surface{surface};
}
domainEntities[] = Extrude {{0, 1, 0}, {0, 0, 0}, -wedgeAngle}
{
    Surface{surface};
    Layers{1};
    Recombine;
};

Physical Surface("wedge0") = {surface};
Physical Surface("wedge1") = {domainEntities[0]};
Physical Surface("walls") = {domainEntities[2], domainEntities[{4 : 6}], domainEntities[8]};
Physical Surface("inlet") = {domainEntities[9]};
Physical Surface("fan_outlet") = {domainEntities[3]};
Physical Surface("outlet") = {domainEntities[7]};

Physical Volume(1000) = {domainEntities[1]};

