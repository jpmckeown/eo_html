const Pop_2017 = document.querySelector('#Pop_2017');
const Sustain_pop = document.querySelector('#Sustain_pop');
const Growth_rate_pop = document.querySelector('#Growth_rate_pop');
const Modern_contracept = document.querySelector('#Modern_contracept');
const Species_threat = document.querySelector('#Species_threat');
const Sustain_rank = document.querySelector('#Sustain_rank');

const Pop_2017_ = document.querySelector('#Pop_2017_');
const Sustain_pop_ = document.querySelector('#Sustain_pop_');
const Growth_rate_pop_ = document.querySelector('#Growth_rate_pop_');
const Modern_contracept_ = document.querySelector('#Modern_contracept_');
const Species_threat_ = document.querySelector('#Species_threat_');
const Sustain_rank_ = document.querySelector('#Sustain_rank_');

const event = new MouseEvent(mouseenter.type, mouseenter);
Pop_2017.addEventListener('click', function (event) {
  // console.log('Element clicked through function!');
  // event.preventDefault();
  Pop_2017_.dispatchEvent(event);
});