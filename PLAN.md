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

## Entities

- [ ] Automobile
- [ ] Box object
- [ ] Building (?)

## Scrolling

For now, implement a simple scroll that is centered to the player. Eventually the scroll can be more dynamic.

- [ ] ?

## Movement System

The game uses a movement mechanism similiar to SharkBite Bay Adventure. We can note the following aspects in SharkBite Bay Adventure:

- You use only directionals to move.
- Moving to a direction causes a rotation tween. One tween from a next direction input cancels the previous tween.
- You can combine directionals to move towards a diagonal angle.

Implementation:

- [ ] Do not let car idle on a diagonal
- [ ] Unapply acceleration from a previous direction