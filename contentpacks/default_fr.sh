    #### Content pack informations ####

packName="Default"
packAuthor="Quôzul"

defaultWeapon=stick

declare -A itemName ; declare -A itemType ; declare -A itemMinHealthRestore ; declare -A itemMaxHealthRestore ; declare -A itemMinDamage ; declare -A itemMaxDamage
## DO NOT TOUCH THE LINE ABOVE OTHERWISE THE GAME WILL NOT DETECT ANY OF YOUR ITEMS

    ######## Items list ########

itemName[meat]="viande"
itemType[meat]="healthcare"

itemHealthRestore[meat]=1-2

itemName[leather]="cuir"
itemType[leather]="craft"

itemName[stick]="bâton"
itemType[stick]="sword"

itemDamage[stick]=1-2

itemName[apple]="pomme"
itemType[apple]="healthcare"

itemHealthRestore[apple]=1-2

itemName[diamond]="diamant"
itemType[diamond]="craft"


entityName[1]="cochon"
entityType[1]="animal"

entityExp[1]=0-1

entityHealth[1]=2
entityCanRecoverHealth[1]=false

entityCommonDrop[1]=meat
entityHaveCommonDrop[1]=2

entityUniqueDrop[1]=""
entityUniqueDropChance[1]=0

entityName[2]="cheval"
entityType[2]="animal"

entityExp[2]=1-2
entityCanBeTamed[2]=apple

entityHealth[2]=4
entityCanRecoverHealth[2]=false

entityDamage[2]=0-2
entityEscapeChance[2]=85

entityCommonDrop[2]=meat
entityHaveCommonDrop[2]=3

entityUniqueDrop[2]=leather
entityUniqueDropChance[2]=50

entityName[3]="dragon"
entityType[3]="animal"

entityExp[3]=10-15

entityHealth[3]=10
entityCanRecoverHealth[3]=true

entityDamage[3]=2-4
entityEscapeChance[3]=25

entityCommonDrop[3]=meat
entityHaveCommonDrop[3]=3

entityName[4]="pommier"
entityType[4]="plant"

entityCommonDrop[4]=apple
entityHaveCommonDrop[4]=3

entityName[5]="coffre"
entityType[5]="plant"

entityExp[5]=10-15

entityHealth[5]=2

entityDamage[5]=1-2
entityEscapeChance[5]=35

entityCommonDrop[5]=diamond
entityHaveCommonDrop[5]=1


entityCount=${#entityName[@]}  ## DO NOT TOUCH THIS LINE OTHERWISE THE GAME WILL NOT DETECT ANY OF YOUR ENTITY
