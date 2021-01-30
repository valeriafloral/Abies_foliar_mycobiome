#!/bin/bash

#SBATCH -w nodo3
#SBATCH -n 6

# Valeria Flores
#27/01/2021
#Download KrakenUniq database


krakenuniq-download --db ../../programas/kraken/DB --taxa "archaea,bacteria,viral,fungi,protozoa,helminths" --dust --exclude-environmental-taxa microbial-nt

