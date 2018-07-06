#!/bin/bash

# info dev : à régler
# ajoute la consomation de viande - a régler: bug de suppression de plein d'items lorsque l'on consomme une viande

  ## GAME INFORMATIONS

col=$(tput cols)
row=$(tput lines)

source options
source contentpacks/$current_contentPack
source lang/$setting_lang

  ## PLAYER INFORMATIONS

plyAge=0
plyHealth=10
plyMaxHealth=10 # Unused
plyBag=($defaultWeapon)
plyBagMax=8 # Unused
plyExp=0
plyMoney=0
plyWeapon=$defaultWeapon
plyPet=

  ## GUI

function plyInfo() {
    tput cup 2 $(($col/2+2))
    echo "${lang_health^}: $plyHealth / $plyMaxHealth  " # Display health

    tput cup 3 $(($col/2+2))
    echo "${lang_exp^}: $plyExp" # Display exp

    tput cup 4 $(($col/2+2))
    echo "${lang_balance^}: $plyMoney $" # Display money

    tput cup 6 $(($col/2+2))
    echo "${lang_weapon^}: ${itemName[$plyWeapon]^}"

    tput cup 7 $(($col/2+2))
    echo -n "${lang_pet^}: "
    if [ "$plyPet" == "" ]; then
        echo "${lang_none^}"
    else
        echo "${entityName[$plyPet]^}"
    fi

    tput cup 9 $(($col/2+2))
    echo "${lang_bag^}: ${#plyBag[@]} / $plyBagMax"

    tput cup 10 $(($col/2+2))
    echo "${lang_item^}: "

    if [ "${#plyBag[@]}" != 0 ]; then # Maybe this line is useless
        i=0
        tput cup 20 $(($col/2+2))

        while [ "$i" -lt "$plyBagMax" ]; do
            tput cup $((11+$i)) $(($col/2+3))
            echo -n "$i. "

            if [ "${plyBag[$i]}" ]; then
                echo "${itemName[${plyBag[$i]}]^} "
            else
                echo "${lang_empty^}"
            fi

            i=$(($i+1))
        done
    fi
}

  #### THE ACTUAL GAME ####

function adventure() {
    currentEntity=$(shuf -i1-$(($entityCount)) -n1)

    function harvest() {
        currentEntityCommonDropAmount=$(shuf -i1-${entityHaveCommonDrop[$currentEntity]} -n1)
        tput cup 6 2 ; echo "${lang_loot^}:"
        tput cup 7 3 ; echo "x$currentEntityCommonDropAmount ${itemName[${entityCommonDrop[$currentEntity]}]}"

        i=0
        while [ "$i" -lt "$currentEntityCommonDropAmount" ]; do
            plyBag+=(${entityCommonDrop[$currentEntity]}) # Add drop to inventory
            i=$(($i+1))
        done
    }

    function fight() { # En combat contre l'entité
        currentEntityHealth=${entityHealth[$currentEntity]}

        while [ "$currentEntityHealth" -gt "0" ]; do
            tput cup 10 2

            damage=$(shuf -i${itemDamage[$plyWeapon]} -n1) # Choose how many damage the player will deal to the entity
            echo -n "${lang_playerInflicted^}: $damage ${lang_damage} "

            if [ "$plyPet" != "" ]; then
                petDamage=$(shuf -i${entityDamage[$plyPet]} -n1) # Choose how many damage the pet of the player will deal to the entity
                damage=$(($damage+$petDamage))

                echo "+ $petDamage"
            fi

            currentEntityHealth=$(($currentEntityHealth-$damage)) # Remove health from the entity

            if [ "${entityDamage[$currentEntity]}" -a "${entityDamage[$currentEntity]}" != "0" ]; then # If the entity can damage the player
                damage=$(shuf -i${entityDamage[currentEntity]} -n1)

                tput cup 11 2
                echo "${lang_entityInflicted^}: $damage ${lang_damage} "
                plyHealth=$(($plyHealth-$damage))

                tput cup 2 $(($col/2+2))
                echo "${lang_health^}: $plyHealth / $plyMaxHealth " # Display health of the player

                if [ "$plyHealth" -le "0" ]; then # If the player die
                    tput cup 16 2
                    echo "${lang_playerDie_combat^}"
                    exit
                fi

                tput cup 3 2
                echo -n "${lang_health^}: $currentEntityHealth " # Display health of the entity
            fi

            tput cup $(($row-3)) 3

            if [ "$currentEntityHealth" != "0" ]; then
                echo -n "1. ${lang_attack^}  2. ${lang_runAway^}  " #Display available choice
                read -srn1 tmpVar # Ask the player to choice
            else
                break
            fi

            if [ "$tmpVar" == 2 ]; then
                if [ "${entityEscapeChance[$currentEntity]}" != "" -a "$(shuf -i0-100 -n1)" -le "${entityEscapeChance[$currentEntity]}" ]; then
                    break
                else
                    tput cup 14 2
                    echo "${lang_runAwayFailed^}"
                fi
            fi
        done

        if [ "$currentEntityHealth" -lt "1" ]; then
            entityDeath # Call a function
        fi
    }

    function entityDeath() {  ## Mort de l'entité
        tput cup 6 2 ; echo "${lang_loot^}:"

        tput cup 7 3
        if [ "${entityHaveCommonDrop[$currentEntity]}" != "0" -a "${#plyBag[@]}" -lt "$plyBagMax" ]; then
            currentEntityCommonDropAmount=$(shuf -i1-${entityHaveCommonDrop[$currentEntity]} -n1) # Choose the amount of common drop
            echo "x$currentEntityCommonDropAmount ${itemName[${entityCommonDrop[$currentEntity]}]}"

            i=0
            while [ "$i" -lt "$currentEntityCommonDropAmount" ]; do
                plyBag+=(${entityCommonDrop[$currentEntity]}) # Adding common drop to inventory
                i=$(($i+1))
            done

            if [ -n "${entityUniqueDropChance[$currentEntity]}" -o "${entityUniqueDropChance[$currentEntity]}" != 0 ]; then # If can drop unique drop
                if [ "$(shuf -i0-100 -n1)" -le "${entityUniqueDropChance[$currentEntity]}" ]; then
                    tput cup 8 3
                    echo "x1 ${itemName[${entityUniqueDrop[$currentEntity]}]}"
                    plyBag+=(${entityUniqueDrop[$currentEntity]}) # Adding unique drop to inventory
                fi
            fi


        elif [ "${#plyBag[@]}" -ge "$plyBagMax" ]; then
            echo "${lang_playerBagFull^}"
        else
            echo "${lang_lootNothing^}"
        fi

        if [ -n "${entityExp[$currentEntity]}" -a "${entityExp[$currentEntity]}" != "0" ]; then # Exp system
            tput cup 5 2
            tmpVar=$(shuf -i${entityExp[$currentEntity]} -n1)
            plyExp=$(($plyExp+$tmpVar))
            echo "${lang_gainExp^}: $tmpVar"
        fi
    }

    function inventory() {
        tmpVar=0

        while :
        do
            tput cup 15 2

            echo "${lang_selectAnItem^}"
            read -rn2 tmpVar # Ask the player to choice

            case $tmpVar in
                $'\e') break;;
            esac

            if [ "${itemType[${plyBag[$tmpVar]}]}" == "healthcare" ]; then
                if [ "$plyHealth" -lt "$plyMaxHealth" ]; then
                    health=$(shuf -i${itemHealthRestore[${plyBag[$tmpVar]}]} -n1)
                    plyHealth=$(($plyHealth+$health))
                    unset plyBag[$tmpVar]
                    break
                fi
                echo "${lang_cantUseItem^}"
            elif [ "${plyBag[$tmpVar]}" == "$plyWeapon" ]; then
                echo "${lang_cantUseItem^}"
            else
                unset plyBag[$tmpVar]
            fi
        done
    }

    function tame() {
        tput cup 6 2

        declare -A map
        for key in "${!plyBag[@]}"
        do
            map[${plyBag[$key]}]="$key"
        done

        if [[ -n "${map[${entityCanBeTamed[$currentEntity]}]}" ]]; then
            unset plyBag[${map[${entityCanBeTamed[$currentEntity]}]}]
            echo "${lang_tameSucces^} \"${entityName[$currentEntity]^}\""
            plyPet=$currentEntity

            if [ -n "${entityExp[$currentEntity]}" -a "${entityExp[$currentEntity]}" != "0" ]; then # Exp system
                tput cup 5 2
                tmpVar=$(shuf -i${entityExp[$currentEntity]} -n1)
                plyExp=$(($plyExp+$tmpVar))
                echo "${lang_gainExp^}: $tmpVar"
            fi
        else
            echo "${lang_tameFail^} \"${entityName[$currentEntity]^}\""
        fi
    }

    tput cup 2 2
    echo -n "${lang_entity^}: ${entityName[$currentEntity]^}"

    if [ "${entityType[$currentEntity]}" == "plant" ]; then

        tput cup 3 2
        echo -n "${lang_product^}: $lang_upTo ${entityHaveCommonDrop[$currentEntity]} ${itemName[${entityCommonDrop[$currentEntity]}]}"

        tput cup $(($row-3)) 3
        echo -n "1. ${lang_harvest^}  2. ${lang_inventory^}  3. ${lang_runAway^}"

    elif [ "${entityType[$currentEntity]}" == "animal" ]; then

        tput cup 3 2
        echo -n "${lang_health^}: ${entityHealth[$currentEntity]}"

        tput cup $(($row-3)) 3
        echo -n "1. ${lang_attack^}  2. ${lang_inventory^}  3. ${lang_runAway^}"

    fi

    if [ "${entityCanBeTamed[$currentEntity]}" ]; then
        echo -n " 4. ${lang_tame^} "
    fi
    read -srn1 tmpVar # Ask the player to choice

    if [ "$tmpVar" == "1" -a "${entityType[$currentEntity]}" == "animal" ]; then
        fight # Call a function
    elif [ "$tmpVar" == "1" -a "${entityType[$currentEntity]}" == "plant" ]; then
        harvest # Call a function
    elif [ "$tmpVar" == "2" ]; then
        inventory # Call a function
    elif [ "$tmpVar" == "3" -a "${entityEscapeChance[$currentEntity]}" != "" ]; then
        if [ "${entityEscapeChance[$currentEntity]}" -lt "50" -a "$(shuf -i0-100 -n1)" -le "${entityEscapeChance[$currentEntity]}" ]; then
            damage=$(shuf -i${entityDamage[currentEntity]} -n1)

            tput cup 11 2
            echo "${lang_entityInflicted^}: $damage ${lang_damage} "
            plyHealth=$(($plyHealth-$damage))

            tput cup 14 2
            echo "${lang_runAwayFailed^}"
            fight # Call a function
        fi
    elif [ "$tmpVar" == "4" -a "${entityCanBeTamed[$currentEntity]}" ]; then
        tame # Call a function
    fi

}

while [ "$plyHealth" -gt "0" ]
do
    clear
    plyInfo # Call a function
    adventure # Call a function
    sleep 1 # Sleep 1 second
done

tput cup $(($row-2)) 0
