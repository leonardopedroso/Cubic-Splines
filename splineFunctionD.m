function DyG = splineFunctionD(xG,x,y,M)
%% Descrição
% A função splineFunction é a que com base nos pares (x,y)
% e nas segundas derivadas do spline interpolador anteriormente
% calculadas retorna o valor da derivada spline em pontos 
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
% ao valor que a primeira derivada do spline interpolador toma 
% para cada entrada de xG. É de notar que o espaçamento entre nós 
% pode não ser uniforme 
%% Gerar pontos da primeira derivada

    DyG = zeros(size(xG)); % instanciar o vetor yG
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
       
       % Calcular o valor que a derivada do spline toma
       % (cf. relatório)
       DyG(j) = - M(i)*((x(i+1)-xG(j))^2)/(2*h)...
                + M(i+1)*((xG(j)-x(i))^2)/(2*h)...
               + (y(i+1)-y(i))/h - ((M(i+1)-M(i))*h)/6;
    end

end
