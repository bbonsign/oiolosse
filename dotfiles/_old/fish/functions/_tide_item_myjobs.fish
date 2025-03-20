function _tide_item_myjobs
   test (jobs | wc -l) -gt 0 && _tide_print_item  myjobs $tide_myjobs_icon "$(jobs | wc -l)"
end
