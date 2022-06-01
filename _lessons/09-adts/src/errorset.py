INT_BITS = 32

def getIndex(element):
  index = int(element / INT_BITS)
  offset = element % INT_BITS
  bit = 1 << offset
  return (index, bit)

class Set:
  def __init__(self, capacity):
    self.vector = [0] * (1 + int(capacity / INT_BITS))
    self.capacity = capacity

  def add(self, element):
    (index, bit) = getIndex(element)
    self.vector[index] |= bit

  def delete(self, element):
    (index, bit) = getIndex(element)
    self.vector[index] &= ~bit

  def contains(self, element):
    (index, bit) = getIndex(element)
    return (self.vector[index] & bit) > 0

############

class ErrorSet(Set):
  def checkIndex(self, element):
    if (element > self.capacity):
      raise IndexError(str(element) + " is out of range.")

  def add(self, element):
    self.checkIndex(element)
    Set.add(self, element)
    print(element, "successfully added.")

  def delete(self, element):
    self.checkIndex(element)
    Set.delete(self, element)
    print(element, "successfully removed.")

  def contains(self, element):
    if element > self.capacity:
      return false
    else:
      return Set.contains(self, element)

def fill(s, b, e):
  for i in range(b, e):
    s.add(i)
