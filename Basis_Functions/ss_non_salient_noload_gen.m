function [e_fA, e_fB, e_fC] = ss_non_salient_noload_gen(t, I_f, N_f, N_a, Rel, omega)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

e_fA = omega * ((N_a * N_f) / Rel) * I_f * sin(omega * t);
e_fB = omega * ((N_a * N_f) / Rel) * I_f * sin((omega * t) - 2*pi/3);
e_fC = omega * ((N_a * N_f) / Rel) * I_f * sin((omega * t) - 4*pi/3);


end

