

UI.AddCheckbox( 'Adaptive changer' )

const get_skin_dropdown = function( str ) {
    switch ( str ) {
        case 'ak 47': return 0
        case 'aug': return 1
        case 'awp': return 2
        case 'pp bizon': return 3
        case 'cz75 auto': return 4
        case 'desert eagle': return 5
        case 'dual berettas': return 6
        case 'famas': return 7
        case 'five seven': return 8
        case 'g3sg1': return 9
        case 'galil ar': return 10
        case 'glock 18': return 11
        case 'p2000': return 12
        case 'm249': return 13
        case 'm4a4': return 14
        case 'm4a1 s': return 15
        case 'mac 10': return 16
        case 'mag 7': return 17
        case 'mp7': return 18
        case 'mp5 sd': return 19
        case 'mp9': return 20
        case 'negev': return 21
        case 'nova': return 22
        case 'p250': return 23
        case 'p90': return 24
        case 'r8 revolver': return 25
        case 'sawed off': return 26
        case 'scar 20': return 27
        case 'sg 553': return 28
        case 'ssg 08': return 29
        case 'tec 9': return 30
        case 'ump 45': return 31
        case 'usp s': return 32
        case 'xm1014': return 33
        case 'bayonet': return 34
        case 'flip knife': return 35
        case 'gut knife': return 36
        case 'karambit': return 37
        case 'm9 bayonet': return 38
        case 'butterfly knife': return 39
        case 'falchion knife': return 40
        case 'navaja knife': return 41
        case 'shadow daggers': return 42
        case 'stiletto knife': return 43
        case 'bowie knife': return 44
        case 'huntsman knife': return 45
        case 'talon knife': return 46
        case 'ursus knife': return 47
        case 'classic knife': return 48
        case 'paracord knife': return 49
        case 'survival knife': return 50
        case 'nomad knife': return 51
        case 'skeleton knife': return 52
    }
}

const skin_changer = function( ) {
    if ( !UI.GetValue( 'Adaptive changer' ) )
        return
    
    const weapon = Entity.GetName( Entity.GetWeapon( Entity.GetLocalPlayer( ) ) )
    UI.SetValue( 'Misc', 'SKINS', 'Skins', 'Weapon', get_skin_dropdown( weapon ) )
}

const on_create_move = function( ) {
skin_changer( )
}

Global.RegisterCallback( 'CreateMove', 'on_create_move' )

