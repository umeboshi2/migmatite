Backbone = require 'backbone'
Marionette = require 'backbone.marionette'

PIXI = require 'pixi'
p2 = require 'p2'
Phaser = require 'phaser'

tc = require 'teacup'


{ remove_trailing_slashes
  make_json_post
  random_choice } = require 'agate/src/apputil'

MainChannel = Backbone.Radio.channel 'global'




########################################
# Templates
########################################
PhaserViewTemplate = tc.renderable (model) ->
  tc.div '#phaserdemo'
########################################





collect_the_damned_star = (player, star) ->
  console.log 'collect_the_damned_star', player, star
  star.kill()

class DemoObject extends Backbone.Marionette.Object



class DemoGame extends Backbone.Marionette.Object
  create_background: ->
    # A simple background for our game
    @game.add.sprite 0, 0, 'sky'

  create_platforms: ->
    #  The platforms group contains the ground and the 2 ledges we can jump on
    @platforms = @game.add.group()
    #  We will enable physics for any object that is created in this group
    @platforms.enableBody = true
    #  Here we create the ground. (example uses world.height - 64)
    ground = @platforms.create 0, (@game.world.height - 32), 'ground'
    # Scale it to fit the width of the game
    # (the original sprite is 400x32 in size)
    # image should fit 400x300 without scaling
    #ground.scale.setTo(1,2)
    ground.scale.setTo .5, 1
    
    # This stops it from falling away when you jump on it
    ground.body.immovable = true

    ledge = @platforms.create 200, 200, 'ground'
    ledge.body.immovable = true
    ledge.scale.setTo .5, .5
    
    ledge = @platforms.create -75, 125, 'ground'
    ledge.body.immovable = true
    ledge.scale.setTo .5, .5
    
  create_player: ->
    # The player and its settings
    @player = @game.add.sprite 32, (@game.world.height - 150), 'dude'
    #@player.scale.setTo .5, .5
    @player.scale.setTo .5, .5
    
    # We need to enable physics on the player
    @game.physics.arcade.enable @player
    # Player physics properties. Give the little guy a slight bounce.
    @player.body.bounce.y = 0.2
    @player.body.gravity.y = 100
    @player.body.collideWorldBounds = true

    # Our two animations, walking left and right.
    @player.animations.add 'left', [0, 1, 2, 3], 10, true
    @player.animations.add 'right', [5, 6, 7, 8], 10, true


  create_star: (index) ->
    star = @stars.create index*35, index, 'star'
    star.scale.setTo .5, .5
    star.body.gravity.y = 100
    star.body.bounce.y = 0.7 + Math.random() * 0.2
    
  create_stars: ->
    @stars = @game.add.group()
    @stars.enableBody = true
    for i in [0...12]
      #star = @stars.create i*35, i, 'star'
      #star.scale.setTo .5, .5
      #star.body.gravity.y = 100
      #star.body.bounce.y = 0.7 + Math.random() * 0.2
      #star.body.bounce.y = 0.7 + (i/12.0) * 0.2
      @create_star i
      
  collect_the_damned_star: (player, star) =>
    star.kill()
    @current_score += 10
    @scoreText.text = "Score: #{@current_score}"
    @create_star random_choice [0...12]
    
demo = new DemoGame()

class PhaserDemo extends Backbone.Marionette.Object
  start: ->
    @game = new Phaser.Game 400, 300, Phaser.AUTO, 'phaserdemo',
      preload: @preload
      create: @create
      update: @update
    demo.game = @game
    
  preload: ->
    @game.load.image 'sky', 'assets/phaserdemo/sky.png'
    @game.load.image 'ground', 'assets/phaserdemo/platform.png'
    @game.load.image 'star', 'assets/phaserdemo/star.png'
    @game.load.spritesheet 'dude', 'assets/phaserdemo/dude.png', 32, 48
    

  create: ->
    # We're going to be using physics, so enable the Arcade Physics system
    @game.physics.startSystem Phaser.Physics.ARCADE


    
    # game controls
    @cursors = @game.input.keyboard.createCursorKeys()

    demo.create_background()
    demo.create_platforms()
    demo.create_player()
    demo.create_stars()
    
    demo.current_score = 0
    demo.scoreText = @game.add.text 16, 16, 'score: 0',
      fontSize: '20px'
      fill: 'goldenrod4'
    
    
    #@game.add.sprite 20, 20, 'dude'
    
  update: ->
    #console.log "update->", @game, @
    player = demo.player
    platforms = demo.platforms
    stars = demo.stars
    #console.log '------->', player, platforms, stars
    @game.physics.arcade.collide player, platforms
    @game.physics.arcade.collide stars, platforms

    #@game.collect_the_damned_star = @collect_the_damned_star
    # FIXME: read arcade.overlap
    truefunc = () ->
      true
    thegame = @
    @game.physics.arcade.overlap player, stars, demo.collect_the_damned_star, truefunc, demo
    
    # goofing off
    for star in stars.children
      @game.physics.arcade.accelerateToObject star, player
      
    # reset velocity to zero
    demo.player.body.velocity.x = 0
    
    if @cursors.left.isDown
      demo.player.body.velocity.x = -75
      demo.player.animations.play 'left'
    else if @cursors.right.isDown
      demo.player.body.velocity.x = 75
      demo.player.animations.play 'right'
    else
      demo.player.animations.stop()
      # current animation frame?
      demo.player.frame = 4
    if @cursors.up.isDown and demo.player.body.touching.down
      demo.player.body.velocity.y = -175
      
  collect_the_damned_star: (player, star) =>
    console.log "collectStardsfesdfsdfsdf called", player, star
    star.kill()
    @current_score += 10
    @scoreText.text = "Score: #{@current_score}"

class FrontDoorMainView extends Backbone.Marionette.ItemView
  template: PhaserViewTemplate

  onDomRefresh: ->
    game = new PhaserDemo()
    game.start()
    window.mygame = game


class PhaserView extends Backbone.Marionette.ItemView
  template: PhaserViewTemplate

  onDomRefresh: ->
    game = new PhaserDemo()
    game.start()
    if __DEV__
      window.mygame = game
  
module.exports =
  PhaserView: PhaserView

