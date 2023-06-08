# Plan

## Goal

Damage other players by knocking them. Under a time limit, the player with the greatest HP wins the round. Players whose HP is less than 1 are eliminated.

The game has an almost unique movement system based on SharkBite Bay Adventure.

## Lobbby and game types

The player is initially present in a lobby. A game type can be found by navigating the lobby.

Future game types:

- Knockout
- Racing

## Scrolling

Mimmick SharkBite Bay Adventure's scrolling.

- [ ] ?

## Movement System

The game uses a movement mechanism similiar to SharkBite Bay Adventure. We can note the following aspects in SharkBite Bay Adventure:

- You use only directionals to move.
- Moving to a direction causes a rotation tween. One tween from a next direction input cancels the previous tween.
- You can combine directionals to move towards a diagonal angle.

Implementation:

- [ ] Do not let car idle on a diagonal
- [ ] Unapply acceleration from a previous direction

## Player Hit Spin

When the player is hit it might be desired to spin it for a few seconds. To achieve that, simply rotate the `skin` child of the entity and, once the spin finishes, reset the `skin` rotation.

If the game introduces skills, beware of handling possible bugs. For example: if someone throws a bomb on another car that is currently inactive spinning after a hit, what is the behavior?

## Godot stuff

- Physics
  - Position can be reseted in `_integrate_forces` though `physics_state.transform.origin`. This can be useful for teleports.