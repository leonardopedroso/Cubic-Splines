function Splines()
%% Descrição
% É a função que deverá ser executada pelo utilizador
% Função encarregue de toda a interação com o utilizador. 
% É a função que permite escolher a operação a efetura e os 
% parametros desejados.

%% Menu inicial
    fprintf("Bem vindo! ");    
    fprintf("Selecione das alternativas abaixo a desejada:\n");
    fprintf("1 - Interpolação de uma função e suas derivadas\n");
    fprintf("2 - Estudar a ordem de convergência do erro\n");
    fprintf("3 - Interpolar um modo de vibração de uma viga\n");
    fprintf("4 - Interpolação adaptativa de uma função\n");
    fprintf("5 - Desenhar o spline guardado num ficheiro\n");
    fprintf("Escolha: ");
    
    % Ler a escolha e verificar a a sua validade
    escolha =str2double(input('','s'));
    while(isnan(escolha) || not(escolha == 1 || escolha ==2 || escolha ==3 || escolha == 4 || escolha ==5))
        fprintf('Opção inválida. Escolha:');
        escolha = str2double(input('','s'));
    end
    
    % Escolher a operação a executar consoanete a escolha do utilizador
    switch(escolha)
        case 1
            % Por forma a evitar usar calculo simbóloco apenas é
            % possível representar a primeira e segunda derivada do
            % spline sem análise do erro
            interpolarFuncao();
        case 2
            erro();
        case 3
            vigaVibracao();
        case 4
            adaptativo();
        case 5
          fprintf("Digite o nome do ficheiro para extrair os dados: ");
          filename = input('','s');
          plotSplineFromTxt(filename);
    end

end

%% Funções auxiliares

function interpolarFuncao()
% Função que recolhe todos os parâmetros necessários para 
% interpolar uma função e executa o comando
     d = selecinarFuncaoInteresse();
     k = selecionarFuncao(0);
     s = selecionarSpline();
     [a,b] = selecionarIntervalo();
     n = selecionarNtrocos(s);
     filenameS = saveSplineFileName();
     splineUniform(s-1,k,a,b,n,d,1,filenameS);
end

function erro()
% Função que recolhe todos os parâmetros necessários para fazer
% a análise do erro em função do espaçamento. Em particular, 
% estudar os declive do gráfico log(Emax) vs log(h) por forma a 
% estudar a ordem de convergência do spline escolhido
    k = selecionarFuncao(1);
    s = selecionarSpline();
    [a,b] = selecionarIntervalo();
    errorAnalysis(s-1,k,a,b);
end

function vigaVibracao()
% Função que pede o nome do ficheiro onde estão guardados os 
% dados da viga e executa a interpolação desses dados.
    fprintf("Digite o nome do ficheiro para extrair os dados: ");
    filename = input('','s');
    filenameS = saveSplineFileName;
    beam(filename, filenameS);
end

function adaptativo()
    k = selecionarFuncao(0);
    [a,b] = selecionarIntervalo();
    epsl = limiteErro();
    splineAdaptive(k,a,b,epsl,1);
end

function k = selecionarFuncao(u)
% Função que permite ao utilizador selecionar uma função das já
% predefinidas ou introduzir uma nova função.
% Recebe u que para: u = 1 o utilizador não pode definir uma função
%                  : u = 0 o utilizador pode definir uma função 
    fprintf("\nSelecione a função a interpolar:\n");
    fprintf("1 - log(1+x)\n");
    fprintf("2 - 1/(1+25*x^2)\n");
    fprintf("3 - sin(x^2)\n");
    fprintf("4 - tanh(x)\n");
    fprintf("5 - sin(pi*x)\n");
    if(u==0)
        fprintf("6 - Introduzir outra função\n");
    end
    fprintf("Escolha: ");
    
    k =str2double(input('','s')); %verificar aa validade da escolha
    while(isnan(k) || not(k == 1 || k ==2 || k ==3 || k == 4 || k == 5 || k == 6-u))
        fprintf('Opção inválida. Escolha:');
        k = sscanf(input('','s'), "%d");
    end
    % se o utilizador escolher a função a variável k passa a ser
    % um 'function_handle' que a função funChoice consiguirá 
    %intrepertar corretamente
    if(k == 6) 
         fprintf("Introduzir função de variável x: ");
         k = str2func(['@(x)' input('','s')]);  
    end
end

function s = selecionarSpline()
% Função que permite selecionar o tipo de spline interpolador

    fprintf("\nSelecione o tipo de spline a usar:\n");
    fprintf("1 - Natural\n");
    fprintf("2 - Completo\n");
    fprintf("3 - Not-a-Knot\n");
    fprintf("Escolha: ");
    
    s =sscanf(input('','s'),"%d");
    % verificar a avalidade da escolha
    while(isnan(s) || not(s == 1 || s ==2 || s ==3 || s == 4))
        fprintf('Opção inválida. Escolha:');
        s =sscanf(input('','s'),"%d");
    end
end

function [a,b] = selecionarIntervalo()
% Função que permite selecionar o intervalo no qual será feita a
% interpolação
    fprintf("\nÉ imperativo que a função escolhida esteja definida no intervalo selecionado.\n");
    fprintf("Defina o intervalo a interpolar na forma a,b: ");

    while true % verificar a avalidade do intervalo
        A = sscanf(input('','s'),"%f,%f");
        % verificar que a amplitude do intervalo é superior a 0.03
        if(max(size(A)) == 2 && A(2)> A(1) + 0.03)
            break;
        end
        fprintf("Inválido. Intervalo na forma a,b: ");
    end
    a = A(1);
    b = A(2); 
end

function n = selecionarNtrocos(s)
% Função que permite selecionar o número de troços a usar na 
% interpolação
    fprintf("Número de troços: ");
     while true %verificara a validade ad escolha
        n = sscanf(input('','s'),"%d");
        if(max(size(n)) == 1 && n>0 && not(n<3 && s == 3))
          break;
        elseif(n<3 && s == 3)
          % fprintf em comandos separados por uma questao de
          % formataçãodo código
          fprintf("O spline Not-a-Knot necessita de no mínimo 3 troços.");
          fprinf(" Número de troços: ");
        else
          fprintf("Inválido. Intervalo na forma a,b: ");
        end
        
     end
end

function d = selecinarFuncaoInteresse()
% Função que permite selecionara os gráficos que predende estudar
    fprintf("\nSe decidir estudar derivadas da função poderá, apenas, comparar o valor obtido com o real se optar por uma fução predefinida");
    fprintf("\nSelecione o que pretende estudar:\n");
    fprintf("1 - Função\n");
    fprintf("2 - Função e sua 1ª derivada\n");
    fprintf("3 - Função, 1ª e 2ª derivadas\n");
    fprintf("Escolha: ");
    
    s =sscanf(input('','s'),"%d");
    % verificar a a validade da escolha
    while(isnan(s) || not(s == 1 || s ==2 || s ==3 ))
        fprintf('Opção inválida. Escolha:');
        s =sscanf(input('','s'),"%d");
    end
    
    if(s == 1)
        d = [1 0 0];
    elseif(s == 2)
        d = [1 1 0];
    else
        d = [1 1 1];
    end
end

function filenameS = saveSplineFileName()
%Função que permite ao utilizador introduzir o nome do ficheiro em que
%guardará os dados do spline interpolador
    % fprintf em comandos separados por uma questao de formatação
    % do código
    fprintf("Se não pretender gurdar o spline carregue em ENTER, caso ");
    fprintf("contrário digite o nome do ficheiro em que pretende gurdar: ");
    filenameS = input('','s');
end


function epsl = limiteErro()
    while true %verificara a validade do erro
        fprintf("Introduza o limite do erro desejado: ");
        epsl = sscanf(input('','s'),"%f");
        if(epsl>10*eps)
            break;
        end
        fprintf("Inválido. Limite do erro: ");
    end
end 



