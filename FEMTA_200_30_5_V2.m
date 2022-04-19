clear all;
close all;
clc;

addpath('~/Documents/VIP FEMTA/Fall/CAM-scripts-master');

% Dimensions of piece

XP = 40;
YP = 35;
ZP = 6;

% since facing was 0.25 need depth of 6.25 when part is cut

% Aluminum stock
XS = 127.24;
YS = 67.23;
ZS = 12.79;

% ZERO Z-AXIS TOP!!

Fl = 120;
Flmax = 350;
Fd = 5;
dz = 0.25;
Z0 = dz;

b = 3/8 * 25.4;

N = 1;

file = fopen('./gcode/FEMTA_200_30_5_OP1_ZP_38inEM_SMAX.tap','w');

%% face off top
N = surface_face(file, N, b, Fd, Flmax, [0, 0, 0], 0.7, XS, YS, 1, 0.25, dz, true, true, true);
fclose(file);

%% SQUARE POCKETS

% RHS square pocket
file = fopen('./gcode/FEMTA_200_30_5_OP2_38inEM_SMAX.tap', 'w');
N = square_pocket(file, N, b, Fd, [Flmax, Flmax, Fl], [XP/2+b/2 + b, 0, -dz], 0, 0, XP-12, YP+2*b, 0.85, 4.5, 0.275, false, true, true, true);
fclose(file);


%LHS square pocket
file = fopen('./gcode/FEMTA_200_30_5_OP3_38inEM_SMAX.tap', 'w');
N = square_pocket(file, N, b, Fd, [Flmax, Flmax, Fl], [-XP/2-b/2 - b, 0, -dz], 0, 0, XP-12, YP+2*b, 0.85, 4.5, 0.275, false, true, true, true);
fclose(file);

%% QUARTER ROUNT BIT
% defining quarter round bit 
%.. quarter-round set 1
N = 1;
br = 8;

% We need to calculate the value of X based on buffer and bit
X = 0;
Ps = [6 + b/2 + b + X, 38/2; 6 + b/2 + b + X,-38/2]; % need to double check
Rs = [0];
Ds = [0];
Fls = [250];



%quarter round functions 

file = fopen('./gcode/FEMTA_200_30_5_OP4_3mmQM_SMAX.tap', 'w');
% RHS Polygroove (Quarter Round)
N = poly_groove(file, N, br, 25, Fls, [0, 0, 0], Ps, Rs, Ds, -3, 0, 0.05, 3, 3, true, true, false);
Ps = [-6 - b/2 - b - X, 38/2; -6 - b/2 - b - X, -38/2];
N = poly_groove(file, N, br, 25, Fls, [0, 0, 0], Ps, Rs, Ds, 3, 0, 0.05, 3, 3, false, true, false);

% LHS Polygroove (Quarter Round)
Ps = [6 + b/2 + b + 18 + X, 38/2; 6 + b/2 + b + 18 + X, -38/2];
N = poly_groove(file, N, br, 25, Fls, [0, 0, 0], Ps, Rs, Ds, 3, 0, 0.05, 3, 3, false, true, false);
Ps = [-6 - b/2 - b - 18 - X, 38/2; -6 - b/2 - b - 18 - X, -38/2];
N = poly_groove(file, N, br, 25, Fls, [0, 0, 0], Ps, Rs, Ds, -3, 0, 0.05, 3, 3, false, true, true);
fclose(file);

%% Face off remaining stock from parts
file = fopen('./gcode/FEMTA_200_30_5_OP7_ZP_38inEM_SMAX.tap','w');
N = surface_face(file, N, b, 5, Flmax, [0, 0, 0], 0.7, XP, YP, 1, ZS-ZP-0.25, dz, true, true, true);
fclose(file);

%% Cut out parts
b = 6;
b1 = 3/8*25.4;
Ps = [-40 - b/2 - b, 35/2 + b/2; -b/2 - b, 35/2 + b/2 ; -b/2 - b, -35/2 - b/2; -40 - b/2 - b, -35/2 - b/2; -40 - b/2 - b, 35/2 + b/2];
Rs = [0 0 0 0];
Ds = [0 0 0 0];
Fls = [250 250 250 250];
file = fopen('./gcode/FEMTA_200_30_5_OP5_ZP_38inEM_SMAX.tap','w');
N = poly_groove(file, N, b, 5, Fls, [0, 0, 0], Ps, Rs, Ds, 0, 0, 1, 10, 0.22, true, true, false);
fclose(file);

file = fopen('./gcode/FEMTA_200_30_5_OP6_ZP_38inEM_SMAX.tap','w');
Ps = [b/2 + b, 35/2 + b/2; 40 + b/2 + b, 35/2 + b/2 ; 40 + b/2 + b, -35/2 - b/2; b/2 + b, -35/2 - b/2; b/2 + b, 35/2 + b/2];
N = poly_groove(file, N, b, 5, Fls, [0, 0, 0], Ps, Rs, Ds, 0, 0, 1, 10, 0.22, false, true, true);
fclose(file);