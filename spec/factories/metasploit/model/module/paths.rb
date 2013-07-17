FactoryGirl.define do
  sequence :metasploit_model_module_path_gem do |n|
    "metasploit_model_module_path_gem#{n}"
  end

  sequence :metasploit_model_module_path_name do |n|
    "metasploit_model_module_path_name#{n}"
  end

  sequence :metasploit_model_module_path_real_path do |n|
    pathname = Metasploit::Model::Spec.temporary_pathname.join(
        'metasploit',
        'model',
        'module',
        'path',
        'real',
        'path',
        n.to_s
    )
    Metasploit::Model::Spec::PathnameCollision.check!(pathname)
    pathname.mkpath

    pathname.to_path
  end

  sequence :metasploit_model_module_path_archive_real_path do |n|
    pathname = Metasploit::Model::Spec.temporary_pathname.join(
        'metasploit',
        'model',
        'module',
        'path',
        'archive',
        'real',
        'path',
        "#{n}.#{Metasploit::Model::Module::Path::ARCHIVE_EXTENSION}"
    )
    Metasploit::Model::Spec::PathnameCollision.check!(pathname)
    pathname.parent.mkpath

    pathname.open('wb') do |f|
      f.puts "Metasploit::Module::Module::Path archive #{n}"
    end

    pathname.to_path
  end

  sequence :metasploit_model_module_path_directory_real_path do |n|
    pathname = Metasploit::Model::Spec.temporary_pathname.join(
        'metasploit',
        'model',
        'module',
        'path',
        'directory',
        'real',
        'path',
        n.to_s
    )
    Metasploit::Model::Spec::PathnameCollision.check!(pathname)
    pathname.mkpath

    pathname.to_path
  end

  trait :unnamed_metasploit_model_module_path do
    real_path { generate :metasploit_model_module_path_real_path }
  end

  trait :named_metasploit_model_module_path do
    gem { generate :metasploit_model_module_path_gem }
    name { generate :metasploit_model_module_path_name }
  end
end