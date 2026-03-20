eval_file "./data/sea_ice.rb"
ice_data = @ice_data
sample_path = "./samples/"
use_bpm 55
set :current_month, 0
set :current_year, 1979


live_loop :sea_ice do
  current_month = get[:current_month]
  current_year = get[:current_year]
  stop if current_month >= ice_data.length

  puts "Year: #{current_year}, Month: #{current_month % 12 + 1}"
  puts "Ice extent: #{ice_data[current_month]} million sq km"

  lowest_audible_value = 7.051
  base_note = 40
  note_offset = (ice_data[current_month])
  note = base_note + note_offset

  if note_offset > lowest_audible_value
    set_mixer_control! amp: 1, amp_slide: 6
    with_fx :gverb, mix: 0.9 do
      with_fx :ixi_techno, mix: 0.9 do
        with_fx :echo, mix: 0.9 do
          with_fx :bitcrusher, mix: 0.8 do
            with_fx :slicer, mix: 1 do
              sample sample_path, rrand_i(0, note_offset)
            end
          end
        end
      end
    end
  else
    set_mixer_control! amp: 0, amp_slide: 3
    puts "Ice extent is below historical low point threshold"
    puts "To observe the Arctic is to take the pulse of the planet."
    puts "The Arctic is warming several times faster than Earth as a whole,"
    puts "reshaping the northern landscapes, ecosystems, and livelihoods of Arctic peoples."
  end

  with_fx :bitcrusher, mix: 0.7 do
    play chord(:d, :minor), amp: 0.8
  end
  with_fx :gverb, mix: 0.8 do
    with_fx :echo, mix: 0.9 do
      with_fx :distortion, mix: 0.7 do
        play (knit :a4, 4, :f4, 4, :d3, 8).tick
      end
    end
  end

  current_month += 1
  set :current_month, current_month
  if current_month % 12 == 0
    current_year += 1
    set :current_year, current_year
  end

  sleep 1
end
