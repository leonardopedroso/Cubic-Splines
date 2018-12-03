function y = funChoice(x,k,n)
% Descrição
% A função funChoice é a função que é usada pelas funções: SplineNatural,
% SplineNotAKnot e SplineClamped para obter os valores da função
% interpolada no nós escolhidos e nos pontos selecionados para traçar
% o gráfico. É também usada para obter o valor da primeira e segunda 
% derivadas  
% No caso do SplineClamped é também utilizada para fornecer o 
% valor das derivadas nos nós 0 e n.
% A função recebe como argumentos:
%   - x: um vetor de nós para o quais vão ser calculados o valor da 
% função
%   - k: seleção da função a interpolar
%   - n: inteiro que seleciona a informação a fornecer acerca da
% função
%       - n=0: retorna um vetor com valor da função em cada ponto de x
%       - n=1: retorna um vetor (2x1) com o valor da 1ª derivada nos
% nós extremos
%       - n=2: retorna um vetor com valor de f'_k em cada ponto de x 
%       - n=3: retorna um vetor com valor de f''_k em cada ponto de x 
% É de notar que k pode ser um inteiro ou um 'function_handle' 
% consoante seja uma função predefinida ou defina pelo utilizador,
% respetivamente.

% Funções Usadas e intervalos normalmente usados
% k -> fk(x)
% f1(x) = log(1+x)      em [0,1]
% f2(x) = 1/(1+25*x^2)  em [-1,1]
% f3(x) = sin(x^2)      em [0, 3*pi/2]
% f4(x) = tanh(x)       em [-20,20]

% Cálculo

if(~isa(k, 'function_handle')) %se a função for predefinida
    if n == 0 % valores da função em x
        switch k
            case 1
                y = log(1+x);
            case 2
                y = 1./(1+25*x.^2);
            case 3
                y = sin(x.^2);
            case 4
                y = tanh(x);
            case 5
                y = sin(pi*x);
            otherwise
                y = NaN(size(x));
        end
    elseif n == 1 % valores da derivada em x(0) e x(end)
        % instanciar o vetor da derivada da função k nos nós extremos
        y = zeros(2,1); 
        switch k
            case 1
                y(1) = 1/(1+x(1));
                y(2) = 1/(1+x(end));
            case 2
                y(1) = -50*x(1)/((1+25*x(1)^2)^2);
                y(2) = -50*x(end)/((1+25*x(end)^2)^2);
            case 3
                y(1) = 2*x(1)*cos(x(1)^2);
                y(2) = 2*x(end)*cos(x(end)^2);
            case 4
                y(1) = 1-tanh(x(1))^2;
                y(2) = 1-tanh(x(end))^2;
            case 5
                y(1) = pi*cos(pi*x(1));
                y(2) = pi*cos(pi*x(end));
            otherwise
                y = NaN(2,1);
        end
    elseif n == 2
        switch k
            case 1
                y = 1./(1 + x);
            case 2
                y = -((50*x)./(1 + 25*x.^2).^2);
            case 3
                y = 2*x.*cos(x.^2);
            case 4
                y = 2./(1+cosh(2*x));
            case 5
                y = pi*cos(pi*x);
            otherwise
                y = NaN(size(x));
        end
            
    elseif n ==3
        
        switch k
            case 1
                y = -1./((1 + x).^2);
            case 2
                y = (5000*x.^2)./(1 + 25*x.^2).^3 -...
                                          50./(1 + 25.*x.^2).^2;
            case 3
                y = 2*cos(x.^2)-4*x.^2.*sin(x.^2);
            case 4
                y = -((8*sinh(x))./(3*cosh(x)+cosh(3*x)));
            case 5
                y = -pi*pi*sin(pi*x);
            otherwise
                y = NaN(size(x));
        end
                
    else
        y = NaN;
    end
else % se a função foi definida pelo utilizador
    if n == 0
        y = zeros(size(x));
        for i = 1:size(x,2)
           y(i) = k(x(i)); 
        end
    else
    % Se a função não for nenhuma das predefinidadas teriamos de usar 
    % cálculo simbólico para determinar o valor da derivada no nós
    % extremos. Assim, decidimos aproximar a derivada através de uma
    % diferença finita com h = 0.00001
        y = zeros(1,2);
        h = 0.00001;
        y(1) = (-3*k(x(1))+4*k(x(1)+h)-k(x(1)+2*h))/((2*h));
        y(2) = (3*k(x(end))-4*k(x(end)-h)+k(x(end)-2*h))/(2*h);
        
    end   
end
end
