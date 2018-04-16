clear
col=$(tput cols)
row=$(tput lines)
center_row=$(($row/2))
center_col=$(($col/2))

#################################################Préparation de la partie##################################################

#. ~/.QuozulGames/rpgconf.sh

#if [ "$game_save" != "" ]; then
#    echo "Sauvegarde trouvé!"
#else

#################################################Création du personnage##################################################

    echo -n "Entrez le nom de votre personnage... "
    #read player_name
    echo -n "Quelle classe voulez-vous utilisez pour votre aventurier? [Guerrier/Archer] "
    #read player_class
    player_health=10
    player_position=countryside
    player_bag=0
    player_bag_meat=0
    player_bag_fruit=0
    player_bag_potion=0
    player_exp=0
    player_money=0

#fi

while :
do

#################################################Actions du joueur##################################################

clear

tput cup 0 $center_col
echo "Sac: $player_bag/10"
tput cup 1 $center_col
echo "Viandes: $player_bag_meat Fruits: $player_bag_fruit Potions: $player_bag_potion"
tput cup 2 $center_col
echo "Vie: $player_health/10 Exp: $player_exp Solde: $player_money"

tput cup 4 0

#################################################Rencontre avec un animal##################################################

if [ "$player_position" = "countryside" ]; then
    player_meets=$(shuf -i0-2 -n1)
    
    if [ "$player_meets" = 1 ]; then
        animal_type=$(shuf -i1-2 -n1)
        animal_super=$(shuf -i1-10 -n1)
        if [ "$animal_type" = 1 ]; then
            animal_name=$(shuf -n1 Animaux_campagne.txt)
            animal_message="c'est un animal passif"
            animal_damage=$(shuf -i0-2 -n1)
            animal_meat_loot=$(shuf -i0-1 -n1)
            animal_exp_loot=$(shuf -i1-2 -n1)
        elif [ "$animal_type" = 2 ]; then
            animal_name=$(shuf -n1 Animaux_fabuleux.txt)
            animal_message="c'est un animal fabuleux"
            animal_damage=$(shuf -i4-8 -n1)
            animal_meat_loot=$(shuf -i1-2 -n1)
            animal_exp_loot=$(shuf -i5-10 -n1)
        fi
        
        ### Si l'animal est énervé
        
        if [ "$animal_super" = 1 ];then
            animal_damage=$(($animal_damage*2))
            animal_super_message=" énervé"
        else
            animal_super_message=""
        fi
        
        echo -n "Vous rencontrez un \033[1;46m$animal_name\033[0m $animal_message$animal_super_message. Voulez-vous le tuer (ou chercher un autre animal)? [o/N]"
        read choice
        if [ "$choice" = o ]; then
            if [ "animal_damage" != 0 ]; then
                echo "Vous avez tué $animal_name et perdu \033[1;46m$animal_damage\033[0m de vos points de vie lors du combat."
                player_health=$(($player_health-$animal_damage))
            else
                echo "Vous avez tué $animal_name mais il ne vous a pas infligé de dégâts."
            fi
            
            ### Récupération de la viande
            
            if [ "$player_bag" -lt 10 ] && [ "$animal_meat_loot" != 0 ]; then
                echo "Vous avez récupéré \033[1;46m$animal_meat_loot viande\033[0m sur cet animal."
                player_bag=$(($player_bag+$animal_meat_loot))
                player_bag_meat=$(($player_bag_meat+$animal_meat_loot))
            elif [ "$player_bag" -ge 10 ]; then
                echo "Vous n'avez rien récupéré car votre sac est plein, vendez vos objets à un marchand pour le vider."
            elif [ "$animal_meat_loot" -le 0 ]; then
                echo "Vous n'avez rien récupéré car l'animal ne vous a rien donné."
            elif [ "$player_bag" -ge 10 ] && [ "$animal_meat_loot" -le 0 ]; then
                echo "Vous n'avez rien récupéré car votre sac est plein ou que l'animal ne vous a rien donné."
            else
                echo "Une érreur inconnue est survenue."
            fi
            
            ### Récupération de l'expérience
            
            echo "L'animal que vous avez tué vous rapporte $animal_exp_loot points d'éxpérience."
                player_exp=$(($player_exp+$animal_exp_loot))
        
        elif [ "$choice" = n ] && [ "$animal_type" != 1 ] && [ "$animal_type" != 3 ]; then
            animal_keep=$(shuf -i1-5 -n1)
            if [ "$animal_keep" = 1 ]; then
                player_health=$(($player_health-$animal_damage))
                echo "$animal_name vous empêche de vous échapper et vous infflige \033[1;46m$animal_damage\033[0m points de dégât."
            fi
        fi

#################################################Rencontre avec un voyageur##################################################

    elif [ "$player_meets" = 2 ]; then
        adventurer_sell_name=$(shuf -n1 adventurer_items.txt)
        
        if [ "$adventurer_sell_name" = "fruit" ]; then
            adventurer_sell_price=$(shuf -i1-2 -n1)
        elif [ "$adventurer_sell_name" = "viande" ]; then
            adventurer_sell_price=$(shuf -i2-4 -n1)
        elif [ "$adventurer_sell_name" = "fiole de soins" ]; then
            adventurer_sell_price=$(shuf -i4-6 -n1)
        fi
        
        echo "Vous rencontrez \033[1;46mun voyageur\033[0m il vous propose de vous vendre ou acheter \033[1;46m$adventurer_sell_name\033[0m pour $adventurer_sell_price."
        
        while :
        do
        
        if [ "$player_money" -le 0 ] && [ "$player_bag" -le 0 ]; then
            echo "Vous n'avez rien sur vous, le marchand vous ignore"
            break
        fi
        
        echo -n "Voulez vous en vendre ou en acheter? [vendre/acheter/rien] "
        read choice
        
        if [ "$choice" = "vendre" ] || [ "$choice" = "acheter" ]; then
            echo -n "Combien souhaitez-vous en $choice? "
            read choice_bis
            
           if [ "$adventurer_sell_name" = "fruit" ]; then
                if [ "$choice" = "vendre" ] && [ "$player_bag_fruit" -ge "$choice_bis" ]; then
                    echo "Vous venez de lui vendre $choice_bis $adventurer_sell_name."
                    player_bag=$(($player_bag-$choice_bis))
                    player_bag_fruit=$(($player_bag_fruit-$choice_bis))
                    player_money=$(($player_money+adventurer_sell_price*$choice_bis))
                elif [ "$choice" = "acheter" ] && [ "$player_money" -ge "$(($adventurer_sell_price*$choice_bis))" ] && [ "$(($player_bag+$choice_bis))" -le 10 ]; then
                    echo "Vous venez d'acheter $choice_bis $adventurer_sell_name."
                    player_bag=$(($player_bag+$choice_bis))
                    player_bag_fruit=$((player_bag_fruit+$choice_bis))
                    player_money=$(($player_money-adventurer_sell_price*$choice_bis))
                else
                    echo "\033[1;31mVous n'avez pas assez de ressources pour éffectuer cette transaction.\033[0m"
                fi
            elif [ "$adventurer_sell_name" = "viande" ]; then                
                if [ "$choice" = "vendre" ] && [ "$player_bag_meat" -ge "$choice_bis" ]; then
                    echo "Vous venez de lui vendre $choice_bis $adventurer_sell_name."
                    player_bag=$(($player_bag-$choice_bis))
                    player_bag_meat=$(($player_bag_meat-$choice_bis))
                    player_money=$(($player_money+adventurer_sell_price*$choice_bis))
                elif [ "$choice" = "acheter" ] && [ "$player_money" -ge "$(($adventurer_sell_price*$choice_bis))" ] && [ "$(($player_bag+$choice_bis))" -le 10 ]; then
                    echo "Vous venez d'acheter $choice_bis $adventurer_sell_name."
                    player_bag=$(($player_bag+$choice_bis))
                    player_bag_meat=$((player_bag_meat+$choice_bis))
                    player_money=$(($player_money-adventurer_sell_price*$choice_bis))
                else
                    echo "\033[1;31mVous n'avez pas assez de ressources pour éffectuer cette transaction.\033[0m"
                fi
            elif [ "$adventurer_sell_name" = "fiole de soins" ]; then                
                if [ "$choice" = "vendre" ] && [ "$player_bag_potion" -ge "$choice_bis" ]; then
                    echo "Vous venez de lui vendre $choice_bis $adventurer_sell_name."
                    player_bag=$(($player_bag-$choice_bis))
                    player_bag_potion=$(($player_bag_potion-$choice_bis))
                    player_money=$(($player_money+adventurer_sell_price*$choice_bis))
                elif [ "$choice" = "acheter" ] && [ "$player_money" -ge "$(($adventurer_sell_price*$choice_bis))" ] && [ "$(($player_bag+$choice_bis))" -le 10 ]; then
                    echo "Vous venez d'acheter $choice_bis $adventurer_sell_name."
                    player_bag=$(($player_bag+$choice_bis))
                    player_bag_potion=$((player_bag_potion+$choice_bis))
                    player_money=$(($player_money-adventurer_sell_price*$choice_bis))
                else
                    echo "\033[1;31mVous n'avez pas assez de ressources pour éffectuer cette transaction.\033[0m"
                fi
            fi
        elif [ "$choice" = "rien" ]; then
            echo "Vous saluez le voyageur."
            break
        else
            echo "Désolé mais cet objet ne peux pas être vendu ou acheter..."
        fi
        
        done
        
#################################################Récolte de fruits##################################################
        
    else
        fruit_name=$(shuf -n1 fruit_names.txt)
        echo "Vous avez trouvé \033[1;46m$fruit_name\033[0m."
        echo -n "Voulez-vous le récolter? [O/n]"
        read choice
        if [ "$player_bag" -lt 10 ] && [ "$choice" != n ]; then
            echo "Vous avez récupéré \033[1;46m$fruit_name\033[0m."
            player_bag=$(($player_bag+1))
            player_bag_fruit=$(($player_bag_fruit+1))
        elif [ "$player_bag" -ge 10 ]; then
            echo "Vous n'avez rien récupéré car votre sac est plein, vendez vos objets à un marchand pour le vider."
        else
            echo "Vous n'avez pas récupéré \033[1;46m$fruit_name\033[0m"
        fi
    
    fi

#################################################Régénération de vie##################################################

while :
do

    if [ "$player_health" -lt 10 ] && [ "$player_health" -gt 0 ]; then
        echo -n "Vous n'avez pas toute votre vie ($player_health), voulez-vous manger quelque chose? [o/N] "
        read choice
        if [ "$choice" = o ]; then
            echo -n "Vous voulez manger de la viande ou des fruits? [viande/fruit/potion] "
            read choice
            if [ "$choice" = "viande" ] && [ "$player_bag_meat" != 0 ]; then
                player_bag=$(($player_bag-1))
                player_bag_meat=$(($player_bag_meat-1))
                
                food_health=$(shuf -i3-4 -n1)
                player_health=$(($player_health+food_health))
                echo "Vous avez mangé une viande et récupéré \033[1;46m$food_health\033[0m points de vie."
                
                break
            elif [ "$choice" = "fruit" ] && [ "$player_bag_fruit" != 0 ]; then
                player_bag=$(($player_bag-1))
                player_bag_fruit=$(($player_bag_fruit-1))
                
                food_health=$(shuf -i1-2 -n1)
                player_health=$(($player_health+food_health))
                echo "Vous avez mangé une viande et récupéré \033[1;46m$food_health\033[0m points de vie."
                
                break
            elif [ "$choice" = "potion" ] && [ "$player_bag_potion" != 0 ]; then
                player_bag=$(($player_bag-1))
                player_bag_potion=$(($player_bag_potion-1))
                
                food_health=$(shuf -i4-6 -n1)
                player_health=$(($player_health+food_health))
                echo "Vous avez bu une fiole de soins et récupéré \033[1;46m$food_health\033[0m points de vie."
                
                break
            else
                echo "Veuillez entrer un choix valide..."
            fi
        else
            echo "Vous n'avez pas mangé..."
            break
        fi
    elif [ "$player_health" -le 0 ]; then
        echo "Vous êtes morts."
        exit
    else
        break
    fi
    
done

#################################################Arrivée dans une ville##################################################

elif [ "$player_position" = "town" ]; then
    echo "Vous êtes dans la ville."
fi

sleep 2

done

#################################################Sauvegarde de la partie actuelle##################################################



