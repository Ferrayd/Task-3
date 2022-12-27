class Station

  attr_reader :name, :trains

  def initialize(name)
    @name = name
    @trains = []
    puts "Построена станция #{name}"
  end

  def get_train(train)
    trains << train
    puts "На станцию #{name} прибыл поезд №#{train.number}"
  end

  def send_train(train)
    trains.delete(train)
    train.station = nil
    puts "Со станции #{name} отправился поезд №#{train.number}"
  end

  def show_trains(type = nil)
      if type
        puts "Поезда на станции #{name} типа #{type}: "
        trains.each{|train| puts train.number if train.type == type}
      else
        puts "Поезда на станции #{name}: "
        trains.each{|train| puts train.number}
      end
  end
end

class Route

  attr_accessor :stations, :from, :to

  def initialize (from, to)
    @stations = [from, to]
    puts "Маршрут #{from.name} - #{to.name}"
  end

  def add_station(station)
    self.stations.insert(-2, station)
    puts "К маршруту #{stations.first.name} - #{stations.last.name} добавлена станция #{station.name}"
  end

  def remove_station(station)
    if [stations.first, stations.last].include?(station)
      puts "Первую и последнюю станции маршрута удалять нельзя!"
    else
      self.stations.delete(station)
      puts "Из маршрута #{stations.first.name} - #{stations.last.name} удалена станция #{station.name}"
    end
  end

  def show_stations
    puts "В маршруте #{stations.first.name} - #{stations.last.name} следующие станции: "
    stations.each{|station| puts " #{station.name}" }
  end
end

class Train

  attr_accessor :speed, :number, :car_count, :route, :station
  attr_reader :type

  def initialize(number, type, car_count)
    @number = number
    @type = type
    @car_count = car_count
    @speed = 0
    puts "Создан поезд № #{number}. Тип: #{type}. Количество вагонов: #{car_count}."
  end

  def stop
    self.speed = 0
  end

  def add_car
    if speed.zero?
      self.car_count += 1
      puts "К поезду №#{number} прицепили вагон. Теперь количество вагонов: #{car_count}."
    else
      puts "Для добавления вагонов необходимо остановиться!"
    end
  end

  def remove_car
    if car_count.zero?
      puts "Все вагоны отцеплены."
    elsif speed.zero?
      self.car_count -= 1
      puts "От поезда №#{number} отцепили вагон. Теперь количество вагонов: #{car_count}."
    else
      puts "На ходу нельзя отцеплять вагоны!"
    end
  end

  def take_route(route)
    self.route = route
    puts "Поезду №#{number} задан маршрут #{route.stations.first.name} - #{route.stations.last.name}"
  end

  def go_to(station)
    if route.nil?
      puts "Для движения задайте маршрут поезда."
    elsif @station == station
      puts "В данный момент поезд №#{@number} и так находится на станции #{@station.name}"
    elsif route.stations.include?(station)
      @station.send_train(self) if @station
      @station = station
      station.get_train(self)
    else
      puts "Станция #{station.name} не включена в маршрут поезда №#{number}"
    end
  end

  def stations_around
    if route.nil?
      puts "Маршрут не задан"
    else
      station_index = route.stations.index(station)
      puts "Поезд на станции #{station.name}."
      puts "Прошлая станция - #{route.stations[station_index - 1].name}." if station_index != 0
      puts "Следующая станция поезда - #{route.stations[station_index + 1].name}." if station_index != route.stations.size - 1
    end
  end
end


station_tmn = Station.new("Тюмень")
station_ekb = Station.new("Екатеринбург")
station_chel = Station.new("Челябинск")
station_ufa = Station.new("Уфа")

route_tmn_ufa = Route.new(station_tmn, station_ufa)
route_tmn_ufa.add_station(station_ekb)
route_tmn_ufa.add_station(station_chel)
route_tmn_ufa.show_stations
route_tmn_ufa.remove_station(station_tmn)
route_tmn_ufa.remove_station(station_chel)
route_tmn_ufa.remove_station(station_ufa)
route_tmn_ufa.show_stations

train1 = Train.new(1,"passenger", 10)
train2 = Train.new(2, "cargo", 25)
train3 = Train.new(3,"passenger", 12)
train4 = Train.new(4, "cargo", 24)

train1.take_route(route_tmn_ufa)
train1.go_to(station_ekb)
train1.go_to(station_chel)

station_chel.show_trains
station_ekb.show_trains

train1.go_to(station_ekb)
train1.go_to(station_chel)

station_tmn.get_train(train2)
station_tmn.get_train(train3)
station_tmn.get_train(train4)

station_tmn.show_trains("cargo")
station_tmn.show_trains("passenger")
train2.stations_around
train1.stations_around
