

close all;
clear all;
%%
dim_x_flasca= 55; %mm
dim_y_flasca= 55; %mm
collimatore= 19; %mm

zero_x= 16.847; %mm
zero_y= 126.85; %mm
zero_y= 126.85+collimatore;
bordo_tra_due_flasche= 16; %mm:
dimensione_maschera=500; %mm


numero_flasche_orizzontali=5;
numero_fasche_verticali=1;
numero_bordi_centrali_tra_due_flasche=numero_flasche_orizzontali-1;
%%
Step_per_flasca_x=ceil(dim_x_flasca/collimatore);
Step_per_flasca_y=ceil(dim_x_flasca/collimatore);

%%
% Creo il vettore delle X => cioè la prima serpentina in orizzontale: 
% a partire dal punto zero la x cresce e decresce un numero n di volte dove 
% n dipende dall'altezza della flasca
%%
for m=1:numero_fasche_verticali;
for k=1:numero_flasche_orizzontali;
    
    X_pos=[zero_x:collimatore:collimatore*Step_per_flasca_x+zero_x];
    [X_pos,perm,nshifts] = shiftdata(X_pos,2);
     X_neg=sort(X_pos,'descend');
     X=[X_pos;X_neg];
     X_positiva = cell(Step_per_flasca_y,1) ; 
     X_negativa = cell(Step_per_flasca_y,1) ;
     
for i=1:Step_per_flasca_y,
     X_positiva{i} = X_pos ;
     X_negativa{i} = X_neg ;
end

     X_all_pos = cat(1,X_positiva{:});
     X_all_neg = cat(1,X_positiva{:}); 

%%
%%% Adesso creo il vettore delle Y => cioè la prima serpentina: a partire dal punto
%%% zero la y decresce un numero n di volte dove n dipende dall'altezza della flasca

  for i=1 :Step_per_flasca_x+1;
        Y_primo_step(i,:)=zero_y ;
  end

Y_decrescente = cell(Step_per_flasca_y,1); 

for i=1:Step_per_flasca_x+1;
    a = [i*collimatore];
    Y_decrescente{i} = Y_primo_step(i)-repmat(a,size(Y_primo_step,1),1);
end
%%
% [Y_primo_step,perm,nshifts] = shiftdata(Y_primo_step,2);
% Y_primo_step_new= num2cell(Y_primo_step)
% for i=1:Step_per_flasca_x+1;
%     Y_decrescente{i}=[Y_primo_step_new,Y_decrescente_old];
% end
%%
%%% Adesso creo il vettore totale%%

primo = cell(Step_per_flasca_y,1);
secondo = cell(Step_per_flasca_y,1);

for i=1:Step_per_flasca_y;
    if mod(i,2)==0 %% se è pari
       tot{i,1}=[X_negativa{i},Y_decrescente{i}];
    else %% se è dispari
       tot{i,1}=[X_positiva{i},Y_decrescente{i}];
    end
   
end
%%
%%% Adesso devo rifare tuttper n volte dove n è il numero di flasche lungo x
%%% quindi uso l'idice k
    k=k+1;
    zero_x=zero_x+collimatore+dim_x_flasca+bordo_tra_due_flasche;
    tutto{k-1,1}=tot;
    
    
end
%%
 tutte_flasche_prima_riga=cell2mat([tutto{:}]);
 % tutte_flasche_prima_riga è una matrice non un vettore 2x1 e con il 
 % comando reshape non vengono riorganizzate nella maniera giusta
 % quindi faccio un ciclo for per dividere le colonne che riguardano lo
 % spsotamento lungo x da quelle che riguardano lo spostamento lungo y
 
 %%

 for i=1:length(tutte_flasche_prima_riga(i,:))
       if mod(i,2)==0
          seleziono_colonne_pari(:,i)= tutte_flasche_prima_riga(:,i)
       else
          seleziono_colonne_dispari(:,i) = tutte_flasche_prima_riga(:,i) 
       end
 end
 %adesso però ho delle matrici con delle colonne di zeri quindi per
 %eliminarle uso il seguente comando:
 
 seleziono_colonne_pari(:,1:2:end)=[] %Rimangono le colonne pari
 seleziono_colonne_dispari(:,2:2:end)=[] %Rimangono le colonne dispari

 % adesso applico il reshape
prova_pari = reshape(seleziono_colonne_pari,[],1);
prova_dispari = reshape(seleziono_colonne_dispari,[],1);

%unisco le colonne spostamento lungo x con quelle spostamento lungo y
prima_riga=[prova_dispari,prova_pari];


zero_y=zero_y+collimatore+dim_y_flasca+bordo_tra_due_flasche;
m=m+1;
end


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% Adesso stabilisco la dose %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

valore_dose=500; %cGy

for i=1 :length(prima_riga(:))/2
        colonna_dose(i,:)=valore_dose;
end
  

prima_riga_con_dose=[prima_riga,colonna_dose];
