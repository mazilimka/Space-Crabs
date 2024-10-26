extends Node

#TODO: лучше объяснить разницу шины событий и отдельного ивента конкретного объекта
signal score_coin_update(coin: int)
signal coin_collected
signal coin_pickup

signal distance_to_start(is_enabled: bool)
signal distance_to_coin(is_enabled: bool)
signal cheats(is_enabled: bool)
