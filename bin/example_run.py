import sys
import os
import pathlib
import click
import logging
import shutil

home = pathlib.Path(os.path.realpath(__file__)).parents[1]
print('application home directory is {}'.format(home))
sys.path.append(str(home/'lib'))

import my_module

@click.command()
@click.option('--show_message', is_flag=True)
@click.option('--show_array', is_flag=True)
def main(show_message, show_array):
    logger = logging.getLogger(__name__)

    my_example = my_module.MyExample()
    if show_message:
        logger.info('printing message ...')
        my_example.info()
    
    if show_array:
        logger.info('printing array ...')
        print(my_example.array)

if __name__ == '__main__':
    log_fmt = '%(asctime)s - %(name)s - %(levelname)s - %(message)s'
    logging.basicConfig(level=logging.INFO, format=log_fmt)
    main()
