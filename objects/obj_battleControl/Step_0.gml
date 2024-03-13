if (test_ready) { // TEMP TESTING BOOL
BattleStateSelectAction();
}
BattleStateVictoryCheck(); // to be honest i don't think i got the turn-based logic down perfectly yet
BattleStateTurnProgession();
test_ready = false;