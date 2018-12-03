function DDyG = splineFunctionDD(xG,x,M)
%% Descrição
% A função splineFunction é a que com base nos pares (x,y) 
% e nas segundas derivadas do spline interpolador anteriormente
% calculadas retorna o valorda segunda derivada spline em pontos
% entre os nós.
% Recebe como argumentos:
%   - xG: os pontos x em que queremos determinar o valor que o
% spline interpolador toma
%   - x: o vetor de nós de interpolação
%   - y: o vetor de valores da função interpolada em cada um 
% dos nós
%   - M: o vetor dos valores da segunda derivada do spline 
% interpolador em cada um dos nós
% Retorna um vetor da mesma dimensão de xG que corresponde 
% ao valor que a segunda derivada do spline interpolador toma para
% cada entrada de xG.
    
%% Gerar pontos da segunda derivada

    DDyG = zeros(size(xG)); % instanciar o vetor yG
    % varrer as entradas de xG e para cada valor calcular o 
    % valor que o spline interpolador toma
    for j = 1:size(xG,2) 
  % calcular o número do troço a que a entrada atual de xG pertence.
       i = 1;
       while i<size(x,2)-1
          if(xG(j)<=x(i+1))
             break
          end
          i = i+1;
       end
       
       h = (x(i+1)-x(i));
       % Calcular o valor que a segunda derivada do spline toma 
       %(cf. relatório)
       DDyG(j) = (M(i))*((x(i+1)-xG(j))/(h)) ...
                        + (M(i+1))*((xG(j)-x(i))/(h));
    end

end
