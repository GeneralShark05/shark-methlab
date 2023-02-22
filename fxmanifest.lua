---@diagnostic disable: undefined-global
fx_version 'cerulean'
games { 'gta5' }

author 'Shark'
description 'fuck around find out'
version '0.0.1'

dependencies { 'ox_lib', 'ox_target', 'ox_inventory', 'ultra-voltlab' }

shared_script '@ox_lib/init.lua'

client_script "client.lua"

server_script "server.lua"