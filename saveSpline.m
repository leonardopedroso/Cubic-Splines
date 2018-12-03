function saveSpline(x,y,M, sfilename)
%% Descrição
% A função saveSpline serve para guardar os dados, se o utilizador 
% assim o pretender
% A função recebe como input:
%   -x: vetor de nós de interpolação
%   -y: vetor do valor da função em cada um dos nós
%   -M: o vetor dos valores da segunda derivada do spline interpolador
% em cada um dos nós
%   -sfilename: o nome do ficheiro onde se irão guardar os valores
% É de notar que o spline fica apenas completamente definido sabendo 
% estes 3 vetores (x,y,M)

%% Guardar
fid = fopen(sfilename, 'wt'); %abrir o ficheiro
for i = 1:size(x,2) 
 % preencher duas colunas do ficheiro txt com os valores de x e de M
    if(i~=1)
       fprintf(fid, '\n');
    end
    % escrever no ficheiro os vetores em coluna
    fprintf(fid, '%f %f %f' ,x(i),y(i),M(i)); 
end
fclose(fid); % fechar o ficheiro

end
