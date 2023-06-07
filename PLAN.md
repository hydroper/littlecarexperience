# Plan

## Goal

Damage other players by knocking them. Under a time limit, the player with the greatest HP wins the round. Players whose HP is less than 1 are eliminated.

The game has an almost unique movement system based on SharkBite Bay Adventure.

## Rooms

The player is present in a room. There are two room types:

- Lobby
- Vanilla

Future room types:

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

When the player is hit it might be desired to spin it for a few seconds. When doing that:

- [ ] 1. Turn the player entity invisible
- [ ] 2. Add an object in the same position as the player's entity and keep that object rotating clockwise