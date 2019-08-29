function [ v_sym] = sym_projection( v )
%SYM_PROJECTION calculate the giometric mean of matrix v and v' witch is in
%some sence a projection on the symetric ralm. 
vt = permute(v,[3,4,1,2]);
v_sym = sqrt(v.*vt);
end

