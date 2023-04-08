---@diagnostic disable: undefined-global
fx_version 'cerulean'
games { 'gta5' }
lua54 'yes'

author 'General Shark'
description 'Advanced Meth Cooking Script'
version '0.0.1'

dependencies { 'ox_lib', 'ox_target', 'ox_inventory', 'ultra-voltlab' }

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_script "client.lua"

server_script "server.lua"