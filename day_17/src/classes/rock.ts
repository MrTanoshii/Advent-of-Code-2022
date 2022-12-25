export default class Rock {
  id: number;
  jet_pattern_start_id: number;
  jet_pattern_end_id: number;
  shape_id: number;
  stack_height_on_settle: number;

  constructor(id, jet_pattern_start_id) {
    this.id = id;
    this.jet_pattern_start_id = jet_pattern_start_id;
  }
}
