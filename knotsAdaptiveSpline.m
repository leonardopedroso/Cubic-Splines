function [x,y,D] = knotsAdaptiveSpline(k,a,b, epsl)
%% Descrição
% Esta função está responsável pela seleção dos nós ótimos para a
% interpolação de uma função f para um algoritmo adaptativo. Na 
% verdade, como indicado no relatório usaremos uma aproximação para
% o majorante do erro. Verificamos que para apenas 2 troços inicais 
% a aproximação é válida o suficiente para a aplicação da aproximação. 
% É claro que para funções mais exóticas é necessário começar com um 
% número de troços mais adequado 

%% Iteração
    % Criar partição inicial com 2 troços e pontso interiores 
    % auxiliares
    x_ = [a:(b-a)/8:b];
    y_ = funChoice(x_,k,0);
    
    % Criar partição inicial com 2 troços sem os pontso auxilires
    x = [a:(b-a)/2:b];
    y = [y_(1) y_(5) y_(9)];
    
    % soma ponderada dos pontos usada para calcular a estimativa da 
    %quarta derivada em ambos os troços
    d4Est1 = estimateD4(1,y_);
    d4Est2 = estimateD4(5,y_);
    
    % estimativa do majorante do erro
    error1 = abs((3125/385)*d4Est1);
    error2 = abs((3125/385)*d4Est2);
    
    % Verificar se cada um dos troços induz um erro superior a epsl
    % Nesse caso divide o intervalo em dois
    if (error2 > epsl)
        [x,y,x_,y_] = divideInterval(x,2,y,epsl,k,x_,y_);
    end
    if(error1 > epsl)
        [x,y,x_,y_] = divideInterval(x,1,y,epsl,k,x_,y_);
    end
    
    % calcular a derivada da função nos nós extremos a partir 
    % de diferenças finitas 
    D = derivativesExterior(x_,y_);
        
end

%% Funções auxiliares

function [x,y,x_,y_] = divideInterval(x,idx,y,epsl,k,x_,y_)
% Função recursiva que divide um intervalo dado em dois e verifica se 
% nesses dois novos intervalos o erro cometido é inferior a epsl. Se 
% não for, a função invoca-se a ela mesma até que o erro seja 
% inferior a epsl
% Recebe como argumentos: 
% - os vetores de nós x e valores respetivos da função
% - os vetores de nós auxiliares e respetivos valores da função
% - o índice no vetor x do primeiro nó no extremo que se pretende 
% dividir
% - k a função usada
% - epsl o limite maximo do erro
                          
    
    % Calcular os pontos auxiliares em cada intervalo 
    [x,y,x_,y_] = updateSupportVectors(x,y,x_,y_,idx,k);
  
    % Calculate error for new interval
    h = zeros(1,size(x,2)-1);
    for i = 2:size(x,2)
       h(i-1) = x(i)-x(i-1);
    end
    
    % Soma ponderada dos pontos usada para calcular a estimativa 
    % da quarta derivada em ambos os troços
    d4Est1 = estimateD4(find(abs(x_-x(idx))<eps),y_);
    d4Est2 = estimateD4(find(abs(x_-x(idx+1))<eps),y_);
   
    % Aproximar o erro
    error1 = (3125/385)*d4Est1;
    error2 = (3125/385)*d4Est2;
    
    if (abs(error2) > epsl) % verifica se o erro é já inferior a epsl
        [x,y,x_,y_] = divideInterval(x,idx+1,y,epsl,k,x_,y_);
    end
    if (abs(error1) > epsl)
        [x,y,x_,y_] = divideInterval(x,idx,y,epsl,k,x_,y_);
    end
end

function [x,y,x_,y_] = updateSupportVectors(x,y,x_,y_,idx,k)
% Função que é chamada quando um intervalo é dividido por forma a 
% atualizar os valores dos vetores de nós e de nós auxiliares na 
% divisão do troço cujo índice do primeiro nó é idx
% Recebe como argumentos:
% - os vetores de nós x e valores respetivos da função
% - os vetores de nós auxiliares e respetivos valores da função
% - o índice no vetor x do primeiro nó no extremo que se pretende 
% dividir
% - k a função usada
    
    % Introduzir um nó no vetor x
    x = [x(1:idx) (x(idx)+x(idx+1))/2 x(idx+1:end)];
    % Introduzir o valor respetivo da função no novo nó. è de notar
    % que não é necessário calcular esse valor novamente uma vez que
    % é um dos nós auxiliares
    y = [y(1:idx) y_(abs(x_-(x(idx+2)+x(idx))/2)< eps) y(idx+1:end)];
    
    % Determinar o índice de x_ do primeiro nó do troço considerado 
    idx_ = find(abs(x_-x(idx))<eps);
    
    % Determinar os novos nós auxiliares
    for i = 1:4
        x_ = [x_(1:idx_) (x_(idx_)+x_(idx_+1))/2 x_(idx_+1:end)];
        y_ = [y_(1:idx_) funChoice((x_(idx_)+x_(idx_+2))/2,k,0)...
                                                 y_(idx_+1:end)];
        idx_ = idx_ +2;
    end
    
end

function d4Est = estimateD4(idx_,y_)
%Função que dado o índice do vetor y_ do primeiro nó do troço 
% considerado retorna a soma ponderada que é usada para aproximar a
% quarta derivada no troço
    d4Est = y_(idx_)-4*y_(idx_+1)+6*y_(idx_+2)-4*y_(idx_+3)+...
                                                        y_(idx_+4);
end

function D = derivativesExterior(x,y)
% Função que utiliza diferencas finitas para calcular um valor 
% aproximado para a primeira derivada nos nós extremos a partir 
% de 5 pontos
    D = zeros(1,2);
    D(1) = ((-50*y(1)+96*y(2)-72*y(3)+32*y(4)-6*y(5))/...
                                                (24*(x(2)-x(1))));
    D(2) = ((50*y(end)-96*y(end-1)+72*y(end-2)-...
                    32*y(end-3)+6*y(end-4))/(24*(x(end)-x(end-1))));
end

