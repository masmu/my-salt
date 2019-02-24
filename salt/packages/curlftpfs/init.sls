{% set oscodename = grains.get('oscodename') %}

curlftpfs:
  pkg:
    - installed
