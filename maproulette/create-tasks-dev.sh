for f in *.geojson; do 
  echo "Processing $f file.."; 
  # curl -vX POST http://dev.maproulette.org/api/admin/challenge/data-sa-gov-au-roads/task/<task_identifier>
done
