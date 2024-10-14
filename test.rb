p "O" * 4
arr = Array.new(6){ Array.new(7, " ")}

# arr.each_with_index do |row, r|
#   row.each_with_index do |_, c|
#     arr[r][c] = r + c
#   end
# end

arr.each {|row| p row}