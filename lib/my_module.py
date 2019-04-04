# python standard and third-party libraries
import numpy as np

class MyExample(object):
    ''' An example class
    '''
    
    def __init__(self):
        self.message = 'This is an example class'
        self._array = np.array([1,2,3,4,5])

    def info(self):
        ''' print out class message
        '''
        print(self.message)

    @property 
    def array(self):
        ''' get the array

        :rtype: :obj:`numpy.ndarray`
        '''
        return self._array
