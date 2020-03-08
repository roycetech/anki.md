# Prints the card to the console for debugging purposes
class CardPrinter
  LOGGER = MyLogger.instance.freeze

  RE_STYLESS = /
    <div    # starting from <div tag.
    [\d\D]* # match absolutely everything.
  /xm.freeze

  # :nocov:
  # Used for debugging only
  def self.print(lst)
    return unless LOGGER.debug?

    LOGGER.debug("Front: \n#{lst[0]}\n\n")
    LOGGER.debug("Back: \n#{lst[1]}\n\n")

    # LOGGER.debug("Front: \n#{ lst[0][re_styleless] }\n\n")
    # LOGGER.debug("Back: \n#{ lst[1][re_styleless] }\n\n")

    # LOGGER.debug("Tag: \n" + lst[2] + "\n\n")
  end
end
# :nocov:
