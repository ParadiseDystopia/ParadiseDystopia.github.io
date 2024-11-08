var old_party_mode = false;

function on_draw( ) {
    var party_mode = UI.GetValue( "MISC", "JAVASCRIPT", "Script items", "party mode" );
    
    if ( old_party_mode != party_mode ) {
        old_party_mode = party_mode;

        Convar.SetString( "sv_party_mode", party_mode ? "1" : "0" );
    }
}

function on_game_newmap( ) {
    var party_mode = UI.GetValue( "MISC", "JAVASCRIPT", "Script items", "party mode" );
    
    Convar.SetString( "sv_party_mode", party_mode ? "1" : "0" );
}

function initialize( ) {
    UI.AddCheckbox( "party mode" );

    Global.RegisterCallback( "Draw", "on_draw" );
    Global.RegisterCallback( "game_newmap", "on_game_newmap" );
}

initialize( );