require 'benchmark'

# Simple Search function
def simple_search text, key
  pos = []
  loop_cnt = text.length - (key.length - 1)
  search_cnt = 0

  loop_cnt.times do |ti|
    find = true

    key.length.times do |ki|
      search_cnt += 1

      if text[ti + ki] != key[ki]
        find = false
        break
      end
    end

    if find
      pos << ti
    end
  end

  p "検索回数 #{search_cnt}"
  pos
end

# BM Search function
def setup_skip key
  @skip_hash = {}
  @skip_hash[:nothing] = key.length

  1.upto (key.length - 1) do |i|
    if @skip_hash[key.reverse[i]].nil?
      @skip_hash[key.reverse[i]] = i.to_i
    end
  end
end

def skip c
  num = @skip_hash[:nothing].to_i

  if @skip_hash.has_key? c
    num = @skip_hash[c].to_i
  end

  num
end

def bm_search text, key
  setup_skip key

  pos = []
  search_cnt = 0
  search_index = key.length - 1

  while search_index < text.length do
    find = true

    key.length.times do |ki|
      search_cnt += 1

      if text[search_index - ki] != key.reverse[ki]
        find = false
        break
      end
    end

    if find
      pos << (search_index - (key.length - 1))
    end

    search_index += skip text[search_index]
  end

  p "検索回数 #{search_cnt}"
  pos
end


p "text = #{ARGV[0]}"
p "key = #{ARGV[1]}"

pos = []

p '-----------------------------------------'
p 'Simple Search function'

result = Benchmark.realtime do
  pos = simple_search ARGV[0], ARGV[1]
end

p "key位置 #{pos}"
p "処理時間 #{1000 * result} ms"


p '-----------------------------------------'
p 'BM Search function'

result = Benchmark.realtime do
  pos = bm_search ARGV[0], ARGV[1]
end

p "key位置 #{pos}"
p "処理時間 #{1000 * result} ms"
