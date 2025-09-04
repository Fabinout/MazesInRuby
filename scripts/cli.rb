# ruby
# frozen_string_literal: true

module CLI
  module_function

  def parse_rows_cols(argv, default_size: 8)
    script = File.basename($PROGRAM_NAME)

    case argv.length
    when 0
      [default_size, default_size]
    when 1
      begin
        x = Integer(argv[0], 10)
        raise ArgumentError if x <= 0
        [x, x]
      rescue ArgumentError
        abort usage(script)
      end
    else
      begin
        x = Integer(argv[0], 10)
        y = Integer(argv[1], 10)
        raise ArgumentError if x <= 0 || y <= 0
        [x, y]
      rescue ArgumentError
        abort usage(script)
      end
    end
  end

  def usage(script)
    "Usage: ruby #{script} [taille] ou ruby #{script} [lignes colonnes]\n" \
    "Exemples: ruby #{script} 10   |   ruby #{script} 20 30"
  end
end
