function M = Thomas(a,b,c,B)
%% Descrição
% Função que recebe as diagonais principais, superior e inferior 
% de uma matriz A tridiagonal e uma matriz coluna B e resolve o 
% sistema de equações lineares AM=B em que A é diagonalmente 
% dominante 
% As referências para o método são indicadas no relatório, 
% ainda que este resultado advenha do caso particular de eliminação 
% de Gauss para matrizes tridiagonais diagonalmente dominantes.

%% Algoritmo
    dim = length(B); % Obter a dimensão de A dimxdim
    beta = b(1) ;
    M(1) = B(1)/beta ;

    for j = 2:dim
        g(j) = c(j-1)/beta ;
        beta = b(j)-a(j)*g(j) ;
        M(j) = (B(j)-a(j)*M(j-1))/beta ;
    end

    % Substituindo de volta
    for j = 1:(dim-1)
        k = dim-j ;
        M(k) = M(k)-g(k+1)*M(k+1) ;
    end
end

