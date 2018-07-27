require 'set'
class Exercise
  @@dimension = 9 - 1 #9
  @@square = ((@@dimension + 1) / 3) - 1 #3*3

  def initialize
    remaining = Set.new([1,2,3,4,5,6,7,8,9])
    @board = []
    0.upto(@@dimension) do |el|
      row = []
      0.upto(@@dimension) do |el|
        row << remaining.dup
      end
      @board << row
    end
  end

  def tick
    while game_is_not_ended
      sleep 1
      find_singularity_row
      find_singularity_square
    end
    print_board "game ended!"
  end

  def fill(x,y,value)
    unless @board[x][y] === value
      print_board("invalid board: trying to delete #{value} from #{x} #{y}")
      exit
    end
    to_check = []
    @board[x][y] = Set.new([value])

    0.upto(@@dimension) do |idx|
      if idx != x
        if  @board[idx][y] === value
          to_check << [idx, y]
        end
        @board[idx][y].delete(value)
      end
      if idx != y
        if  @board[x][idx] === value
          to_check << [x, idx]
        end
        @board[x][idx].delete(value)
      end
    end

    to_check.each do |el|
      x= el[0]
      y=el[1]
      if @board[x][y].size == 1
        fill(x,y,@board[x][y].first)
      end
    end
    print '.'
    # print_board("inserted: #{value} in #{x} #{y}")
  end

  def find_singularity_row
    1.upto(@@dimension) do |el|
      0.upto(@@dimension) do |x|
        count, lastpos = 0 , 0
        0.upto(@@dimension) do |y|
          if @board[x][y] === el
            count+=1
            lastpos = y
          end
        end
        if count == 1
          fill(x,lastpos,el)
        end
      end

      0.upto(@@dimension) do |y|
        count, lastpos = 0 , 0
        0.upto(@@dimension) do |x|
          if @board[x][y] === el
            count+=1
            lastpos = x
          end
        end
        if count == 1
          fill(lastpos,y,el)
        end
      end
    end

  end

  def game_is_not_ended
    0.upto(@@dimension) do |x|
      0.upto(@@dimension) do |y|
        return true if @board[x][y].size > 1
      end
    end
    return false
  end

  def find_singularity_square
    0.upto(@@square) do |offset_x|
      0.upto(@@square) do |offset_y|
        start_x = offset_x * (@@square + 1)
        start_y = offset_y * (@@square + 1)
        1.upto(@@dimension + 1) do |el|
          start_x.upto(start_x + @@square) do |x|
            count, lastpos = 0, 0
            start_y.upto(start_y + @@square) do |y|
              if @board[x][y] === el
                count+=1
                lastpos = y
              end
            end
            if count == 1
              fill(x,lastpos,el)
            end
          end
        end
      end
    end
  end

  def print_board(message)
    before = (' ' * 30)
    output = "\n"
    output += before + "------------#{message}-------------\n"
    0.upto(@@dimension) do |x|
      0.upto(2) do |row|
        output += before + "|"
        0.upto(@@dimension) do |y|
            output +=  "#{@board[x][y] === 3 * row + 1 ? 3 * row + 1 : " "}"
            output +=  "#{@board[x][y] === 3 * row + 2 ? 3 * row + 2 : " "}"
            output +=  "#{@board[x][y] === 3 * row + 3 ? 3 * row + 3 : " "}"
            output +=  "|"
        end
        output +=  "\n"
      end
      output +=  before +"-"+ "#{"-" * 4 * 9}\n"
    end
    puts output
  end
end

a = Exercise.new
a.fill(0,2,4)
a.fill(0,4,9)

a.fill(1,0,9)
a.fill(1,3,4)
a.fill(1,6,5)
a.fill(1,7,6)
a.fill(1,8,8)

a.fill(2,4,5)
a.fill(2,7,2)

a.fill(3,0,7)
a.fill(3,6,9)
a.fill(3,7,1)

a.fill(4,3,6)
a.fill(4,4,3)
a.fill(4,5,1)

a.fill(5,1,6)
a.fill(5,2,2)
a.fill(5,8,4)

a.fill(6,1,5)
a.fill(6,4,4)

a.fill(7,0,3)
a.fill(7,1,4)
a.fill(7,2,6)
a.fill(7,5,7)
a.fill(7,8,5)

a.fill(8,4,6)
a.fill(8,6,3)
a.tick
