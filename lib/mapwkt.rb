# encoding: UTF-8

module MapWKT
  require 'bundler/setup'
  require 'active_support/all'
  
  require_relative 'mapwkt/line_string'
  require_relative 'mapwkt/map'
  require_relative 'mapwkt/multi_line_string'
  require_relative 'mapwkt/multi_point'
  require_relative 'mapwkt/multi_polygon'
  require_relative 'mapwkt/point'
  require_relative 'mapwkt/polygon'
end
