module ApplicationHelper
  def flash_background_color(type)
    case type.to_sym
    when :success then 'bg-flash-messages-green'
    when :danger then 'bg-flash-messages-red'
    when :error then 'bg-flash-messages-yellow'
    else 'bg-gray-500'
    end
  end

  # 取得したサムネイル画像がなかった場合はsample.jpgを付与する
  def google_material_thumbnail(google_material)
    google_material['volumeInfo']['imageLinks'].nil? ? 'no_image.png' : google_material['volumeInfo']['imageLinks']['thumbnail']
  end

  # thumbnailはネストしている配置となっているのでdigを使って取り出す
  # また画像のリンクがhttpとなっているためgsubを使いhttpsに変更する。変更した値をbookImageに代入する
  def google_material_params(google_material)
    google_material['volumeInfo']['image'] = google_material.dig('volumeInfo', 'imageLinks', 'thumbnail')&.gsub('http', 'https')

    # ISBNは13桁と10桁があり、どちら1つを取得できればよいので、最初に検索した値をsystemidに代入する
    isbn_identifier = google_material['volumeInfo']['industryIdentifiers']&.select { |h| h['type'].include?('ISBN') }&.first
    google_material['volumeInfo']['systemid'] = isbn_identifier['identifier'] if isbn_identifier

    # volumeInfoの中が必要な項目のみになるようsliceを使って絞りこむ
    google_material['volumeInfo'].slice('title', 'authors', 'publishedDate', 'infoLink', 'image', 'systemid', 'canonicalVolumeLink')
  end

  # 教材登録時の教材特徴チェックボックス内容
  def experience_levels
    %w[初学者 経験者 1冊で合格 資格合格最低限内容 深掘りした内容 問題数多め 解説が丁寧]
  end

  # タイトル動的表示用
  def page_title(title = '')
    base_title = '教材チョイス'
    title.present? ? "#{title} | #{base_title}" : base_title
  end

  def default_meta_tags
    {
      site: '教材チョイス',
      title: '教材チョイス',
      reverse: true,
      charset: 'utf-8',
      description: '自分に合った教材を見つけられるサービスです',
      keywords: '教材、テキスト、資格、チョイス',
      canonical: request.original_url,
      separator: '|',
      og: {
        site_name: '教材チョイス',
        title: '教材チョイス',
        description: '自分に合った教材を見つけられるサービスです',
        type: 'website',
        url: request.original_url,
        image: image_url('ogp.png'), # 配置するパスやファイル名によって変更する
        locale: 'ja_JP',
      },
      twitter: {
        card: 'summary_large_image', # Twitterで表示する場合は大きいカードに変更
        site: '@', # アプリの公式Twitterアカウントがあれば、アカウント名を記載
        image: image_url('ogp.png') # 配置するパスやファイル名によって変更
      }
    }
  end
end
