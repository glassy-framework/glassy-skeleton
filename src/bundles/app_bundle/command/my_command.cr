require "glassy-console"

module App
  class MyCommand < Glassy::Console::Command
    property name : String = "my:command"
    property description : String = "my description"

    @[Argument(name: "name", desc: "Name of the person")]
    @[Option(name: "fill", desc: "Fill or not?")]
    def execute(name : String, fill : Bool)
      output.writeln("name = #{name}")
      output.writeln("fill = #{fill}")
    end
  end
end
