function objeto=recoge_objeto(entorno,num)
objeto=[];
L=size(entorno,1);

fin=entorno(L,8);%nombre total d'objet

if (num<=fin)
    for i=1:L%nous parcourrons la matrice de l'environnement
        if (entorno(i,8)==num)%nous verifions qu'il s'agit de l'objet voulu
            objeto=[objeto;entorno(i,:)];%si oui nous stockon la ligne dans l'objet
        end
    end
end
