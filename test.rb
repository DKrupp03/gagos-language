x = (2 + 2) * 3
y = 20
if x < y
puts "#{x} é menor que #{y}"
else
puts "#{x} é maior que #{y}"
end
while x < 15
x = x + 1
puts "x = #{x}"
end
for i in 0..5 do
puts "i = #{i}"
end
def media a, b
x = (a + b) / 2
puts x
return x
end
teste = media 0, 5.5
puts teste