require "glassy-console"

class MyCommand < Glassy::Console::Command
  def name : String
    "my:command"
  end

  def description : String
    "my description"
  end

  @[Argument(name: "name", desc: "Name of the person")]
  def execute(name : String)
    output.writeln("name = #{name}")
  end

end
