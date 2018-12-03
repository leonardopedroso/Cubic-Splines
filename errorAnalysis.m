function errorAnalysis(s,k,a,b)
%% Descrição
% A função errorAnalysis tem como objetivo fazer o estudo do erro máximo
% cometido na interpolação por um spline em função do espaçamento entre 
% troços (uniforme)
% Recebe como argumentos:
%   - s: o tipo de spline interpolador
%       - s=0: spline natural
%       - s=1: spline completo
%       - s=2: spline not a knot
%   - k: a função a usar na interpolação
%   - a,b: os extremos do intervalo onde a função fk(x) é interpolada

%% Constantes
    % limitamos o número de troços por uma questão de memória e tempo de
    % execução, ao invés de limitar h
    n0 = 3; % número de troços inicial
    nMax = 1000; % número aproximado de troços máximo

%% Calcular erro
% Sabemos que o erro máximo da interpolação varia com uma potência do
% espaçamento entre nós (cf. relatório). Assim, por forma a determinar essa 
% potência iremos traçar um gráfico da dependência de log(E) com log(h) 
% pelo que a pontência de h será o declive desse gráfico.
% Por forma a que os pontos que calculamos sucessivamente para o gráfico de
% log(E) em função log(h) tenham um espaçameto uniforme a variação de n 
% (número de troços) será exponencial com um fator de 2

    % Instanciar os vetores h e E respetivamente os valores do espaçamento
    % entre troços em cada iteração
    h = zeros(ceil(log2(nMax/n0)),1);
    E = zeros(ceil(log2(nMax/n0)),3);
    
    % Calcular valores iniciais de h e E
    h(1) = (b-a)/n0;
    E(1,:) = splineUniform(s,k,a,b,n0,[1 1 1],0,0);
    
    % Varrer os valores de h e calcular o erro para cada um
    for i = 2:ceil(log2(nMax/n0))
        h(i) = 1/(n0*2^(i-1));
        E(i,:) = splineUniform(s,k,a,b,n0*2^(i-1),[1 1 1],0,0);
    end
   
%% Traçar gráfico e estimar declive
    figure;
    loglog(h,E(:,1)); % traçar o gráfico numa escala logarítmica
    ylabel('log(|Erro_{max}|)  de f(x)');
    xlabel('log(h)');
    %detrminar o declive da reta
    slope = polyfit(log(h),log(E(:,1)),1); 
    fprintf("Declive de log(E) vs log(h) para f(x) é %f com h a variar entre %f e %f\n", slope(1), (b-a)/3,  h(end));
    
    figure;
    loglog(h,E(:,2)); % traçar o gráfico numa escala logarítmica
    ylabel('log(|Erro_{max}|) de f´(x)');
    xlabel('log(h)');
    %detrminar o declive da reta
    slope = polyfit(log(h),log(E(:,2)),1); 
    fprintf("Declive de log(E) vs log(h) para f'(x) é %f com h a variar entre %f e %f\n", slope(1), (b-a)/3,  h(end));
    
    figure;
    loglog(h,E(:,3)); % traçar o gráfico numa escala logarítmica
    ylabel('log(|Erro_{max}|)  de f´´(x)');
    xlabel('log(h)');
    %detrminar o declive da reta
    slope = polyfit(log(h),log(E(:,3)),1); 
    fprintf("Declive de log(E) vs log(h) para f´´(x) é %f com h a variar entre %f e %f\n", slope(1), (b-a)/3,  h(end));
end
