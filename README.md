boiteajeux-email-notifier
=========================


# The usecase

    As a boiteajeux.net Agricola (the board game) player,
    When it's my turn to play,
    I want to be notified by an email about it.


# The architecture

This software is written with [Hexagonal architecture][ha] in mind 
and the picture there illustrates it nicely.

Uncle Bob summarizes it as a [clean architecture][ca] (a "must see" pic there too)

## Goals

The goal was to deliver a running software that:

* works
* it's fun & easy to develop
* ... so:
* looks like a usecase with actors and its logic
* presents its intent clearly, readable
* domain is clean from UI, db or external services
* different concerns as separated

## Components

There is a main "domain component" that is glued to few external ones.

* domain
* persistence
* email service
* http stream fetcher
* html parser

## Glue - Adapters

It's a dumb layer, that only knows how to pass information from one layer to the other.

AOP is used to define "after/before" or "instead" behaviour between domain and other components.



[ha]: <http://alistair.cockburn.us/Hexagonal+architecture>  "Hexagonal Architecture"
[ca]: <http://blog.8thlight.com/uncle-bob/2012/08/13/the-clean-architecture.html> "Clean Architecture"
