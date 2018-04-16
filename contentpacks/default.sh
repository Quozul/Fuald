##################################################
#               Content pack file                #
#    Here you can edit the content of the game   #
#    Feel free to contact quozul@outlook.com     #
#   to upload you content pack on the website    #
##################################################

    #### Content pack informations ####

packName="Default" # Set the name of the pack here
packAuthor="Quôzul" # Set your name here

    #### Game informations ####

defaultWeapon=stick

declare -A itemName ; declare -A itemType ; declare -A itemMinHealthRestore ; declare -A itemMaxHealthRestore ; declare -A itemMinDamage ; declare -A itemMaxDamage
## DO NOT TOUCH THE LINE ABOVE OTHERWISE THE GAME WILL NOT DETECT ANY OF YOUR ITEMS

    ######## Items list ########

  ## Item informations
itemName[meat]="viande"
itemType[meat]="healthcare" # Value can be: "craft" "healthcare" "sword"

  ## Health variables are available if the type of the item is "healthcare"
itemHealthRestore[meat]=1-2 # Range of health the item restore

    #### Second item ####

  ## Item informations
itemName[leather]="cuir"
itemType[leather]="craft"

    #### Third item ####

  ## Item informations
itemName[stick]="bâton"
itemType[stick]="sword"

  ## Attack variables are available if the type of the item is "sword"
itemDamage[stick]=1-2 # Range of damage the item will deal to the enemy

    #### Second item ####

  ## Item informations
itemName[leather]="cuir"
itemType[leather]="craft"

    #### Third item ####

  ## Item informations
itemName[apple]="pomme"
itemType[apple]="healthcare"

  ## Health variables
itemHealthRestore[apple]=1-2

    #### Fourth item ####

  ## Item informations
itemName[diamond]="diamant"
itemType[diamond]="craft"





    ######## Entity list ########

  ## Entity informations & misc variables
entityName[1]="cochon" # Name of the entity
entityType[1]="animal" # Type of the entity - Value can be "animal" "plant"

entityExp[1]=0-1 # How many experience drops the entity - You can remove this line if you don't want the entity to drop experience

  ## Health variables
entityHealth[1]=2 # Maximum health of the animal - Can be removed if the entity is a plant
entityCanRecoverHealth[1]=false # Set it to true if the entity can recover health - Not used yet

  ## Drops variables
entityCommonDrop[1]=meat # Name of an item created above - If $entityHaveCommonDrop is 0 you can remove this line
entityHaveCommonDrop[1]=2 # Maximum amount of common drop - 0 if you don't want the entity to have a common drop

entityUniqueDrop[1]="" # Name of an item created above - If $entityUniqueDropChance is 0 you can remove this line
entityUniqueDropChance[1]=0 # Chance of the unique drop get dropped by the entity in percentage

    #### Second entity ####

  ## Entity informations & misc variables
entityName[2]="cheval"
entityType[2]="animal"

entityExp[2]=1-2
entityCanBeTamed[2]=apple # Indicates if the entity can be tamed with the specified item - If no item is specified, the entity can't be tamed

  ## Health variables
entityHealth[2]=4
entityCanRecoverHealth[2]=false

  ## Attack variables
entityDamage[2]=0-2 # Range of damage the entity can deal - You can remove it if 0
entityEscapeChance[2]=85 # Chance from escaping the entity while fighting - You can remove it if 100

  ## Drops variables
entityCommonDrop[2]=meat
entityHaveCommonDrop[2]=3

entityUniqueDrop[2]=leather # Name of an item created above - If $entityUniqueDropChance is 0 you can remove this line
entityUniqueDropChance[2]=50 # Chance of the unique drop get dropped by the entity in percentage

    #### Third entity #### Exemple of a boss

  ## Entity informations & misc variables
entityName[3]="dragon"
entityType[3]="animal"

entityExp[3]=10-15

  ## Health variables
entityHealth[3]=10
entityCanRecoverHealth[3]=true

  ## Attack variables
entityDamage[3]=2-4
entityEscapeChance[3]=25

  ## Drops variables
entityCommonDrop[3]=meat
entityHaveCommonDrop[3]=3

    #### Fourth entity #### Exemple of a plant

  ## Entity informations & misc variables
entityName[4]="pommier"
entityType[4]="plant"

  ## Drops variables
entityCommonDrop[4]=apple
entityHaveCommonDrop[4]=3

    #### Fifth entity #### Exemple of a mimic

  ## Entity informations & misc variables
entityName[5]="coffre"
entityType[5]="plant"

entityExp[5]=10-15

  ## Health variables
entityHealth[5]=2

  ## Attack variables
entityDamage[5]=1-2
entityEscapeChance[5]=35

  ## Drops variables
entityCommonDrop[5]=diamond
entityHaveCommonDrop[5]=1


entityCount=${#entityName[@]}  ## DO NOT TOUCH THIS LINE OTHERWISE THE GAME WILL NOT DETECT ANY OF YOUR ENTITY
