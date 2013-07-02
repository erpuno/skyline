-module(dashboard).
-compile(export_all).
-include_lib("n2o/include/wf.hrl").

main() -> 
    [ #dtl{file = "dev", bindings=[{title, <<"dashboard">>},{body, body()}]} ].

body()-> index:header()++ [

  #panel{id=content, body=
    #panel{class=[section], body=
      #panel{class=[container], body=
        #panel{class=["row-fluid"], body=[
% data_fields=[{<<"data-spy">>, <<"affix">>}, {<<"data-offset-top">>, <<"200">>}]
          #panel{class=[span3,"docs-sidebar-menu"], data_fields=[{<<"data-spy">>, <<"affix">>}, {<<"data-offset">>, <<"offset:{x:10}">>}], body=
            #list{class=[nav, "nav-list", "docs-sidebar-nav", "affix-top"], body=[
              #li{class=[active], body=#link{url="#overview", body= <<"Overview">>}},
              #li{body=#link{url="#transitions", body= <<"Transitions">>}},
              #li{body=#link{url="#modals", body= <<"Modal">>}},
              #li{body=#link{url="#dropdowns", body= <<"Dropdown">>}},
              #li{body=#link{url="#end", body= <<"The end">>}}
            ]}
          },
          #panel{class=[span9], data_fields=[{<<"data-spy">>, <<"scroll">>}, {<<"data-target">>, <<".docs-sidebar-menu">>}], body=[
            #h1{body= <<"Sample Documentation page">>},
            #p{class=[lead], body= <<"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
              tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,
              quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo
              consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse
              cillum dolore eu fugiat nulla pariatur.">>},
            #section{id=overview, body=[
              #panel{class=["page-header","docs-header"], body=#h2{body= [<<"Overview">>, #small{body= <<"an overview">>}] }},
              #p{body= <<"Eius laborum quidem delectus necessitatibus qui rerum magni doloribus sed soluta quia. aliquid quasi facere qui nam est et repudiandae ut. consequatur fugit aperiam distinctio sit ab minus autem rerum vel voluptas tempore et">>},
              #p{body= <<"Molestias nesciunt et est est error voluptates nemo. nihil ipsum eum modi omnis aliquid consequatur quidem quas. a impedit in quo et pariatur dolores et quam velit aut numquam sit ducimus totam">>},
              #p{body= <<"Et voluptatem inventore veritatis cumque et fuga dolores repellendus est ducimus maxime fugit qui. autem temporibus voluptas totam. qui quis non corporis sit sed suscipit ut distinctio ad quidem amet eum sed cupiditate. voluptatem in et veritatis vitae rerum          ">>},
              #p{body= <<"Molestiae soluta numquam sed dolorem error sunt. labore quod repellat cumque. corrupti velit atque eius est quas libero corporis. repudiandae magnam illo aut itaque facere et">>},
              #p{body= <<"Vel id ipsa consequatur odit autem dicta qui iste at culpa et sunt ad voluptate. aut ipsa est nam. non et dolores consequatur labore ea adipisci in maxime est nihil qui. eveniet id impedit ea in sint esse dicta et sapiente assumenda tempore et. nihil culpa quo perspiciatis cumque consequatur esse. qui doloribus dolorem non sunt blanditiis nesciunt nihil eligendi ea amet quis rerum rem et">>}
            ]},
            #section{id=transitions, body=[
              #panel{class=["page-header", "docs-header"], body=#h2{body= [<<"Transitions">>, #small{body= <<"some transitions">>}]}},
              #p{body= <<"Quia tempore ea esse eos deleniti quis blanditiis sunt in. aspernatur laudantium harum rem quas ipsum nostrum accusantium delectus. et iste rerum dignissimos fugiat suscipit est eum repudiandae quaerat harum          ">>},
              #p{body= <<"Temporibus rem velit praesentium quo. est quod quia magni at id mollitia corrupti voluptatem. inventore iste saepe eum quos itaque natus sequi eius. quibusdam ducimus eum nulla. ut consequuntur cupiditate iusto aliquid illum libero. tenetur accusamus repellendus et et. nam et quis illum laboriosam est">>},
              #p{body= <<"Accusamus veritatis at consequatur quo ut dignissimos dicta excepturi ex. cumque architecto labore sed aut assumenda occaecati eum nam. deleniti at sed nostrum dolorum et voluptate quod vel fuga reprehenderit est vel nihil beatae. fuga est itaque dolorem doloribus nobis ut accusantium quas qui. dolorum nobis commodi nostrum a aut cumque sit est sequi accusamus">>},
              #p{body= <<"Aut accusamus qui distinctio veritatis rerum. corporis pariatur et et minima quia nulla aliquam ab. consequuntur autem sed perspiciatis perspiciatis perspiciatis laboriosam voluptas nulla et inventore et laudantium iste harum. voluptatem saepe unde voluptas non fugit enim inventore consequatur quo">>}
            ]},
            #section{id=modals, body=[
              #panel{class=["page-header","docs-header"], body=#h2{body= [<<"Modals">>, #small{body= <<"Some modals">>}]}},
              #p{body= <<"Voluptate sed autem aut molestiae. aut eum dolorem voluptate aut sit minus eius deleniti voluptatem perspiciatis doloremque. animi voluptatum exercitationem accusantium ducimus laboriosam aut perferendis mollitia quisquam sit. molestias eos eum sapiente fugit quas est eos maxime ad aut recusandae soluta. cupiditate et dolores numquam est consequuntur blanditiis pariatur voluptatem eos. nulla nesciunt dicta doloremque id aliquam provident quia temporibus eos">>},
              #p{body= <<"Est qui nisi commodi. hic quo id nesciunt suscipit amet error minima a consequatur numquam velit eveniet exercitationem est. voluptatibus repellat libero repudiandae expedita sed veniam. inventore mollitia sed provident non rerum voluptates vel cupiditate. est quia ea tenetur occaecati voluptate alias dolorum neque enim enim rerum corporis. itaque corrupti et eos a voluptatum et adipisci dolorem voluptas accusamus placeat omnis. magnam quam sit eligendi et ipsum sunt qui qui ipsa modi aut ab distinctio et">>},
              #p{body= <<"Fuga magnam qui sit ipsum corporis tenetur repellat est odit. tenetur cupiditate sequi ullam vel earum nesciunt est veritatis error dolor tenetur repudiandae exercitationem et. qui voluptatum maiores perspiciatis sunt ut sequi rerum ut voluptas non eveniet quis id. vitae id blanditiis omnis. ratione voluptas dignissimos ullam qui qui voluptatem possimus debitis. dolorem aut soluta non aspernatur iusto eaque quisquam aspernatur qui enim aut eos doloremque fugiat. officia nostrum enim molestiae deserunt qui">>},
              #p{body= <<"Minima in iusto aut sint et sunt asperiores possimus fugiat illo veniam qui provident. voluptatem vitae qui illo. voluptas sunt quia quam voluptas delectus voluptas voluptas aut voluptatem nobis. molestias distinctio dignissimos quasi aut ea cupiditate tenetur sunt et ea exercitationem mollitia. in dolores sint veniam libero consequatur earum sapiente eligendi dolorem consequuntur modi. laboriosam et numquam expedita at voluptate voluptatem eveniet et consequatur illo">>},
              #p{body= <<"Quo rerum consequatur consequatur totam. voluptas aliquam assumenda voluptatem officia aut culpa est. quis asperiores odit laudantium fugit fugiat recusandae          ">>}
            ]},
            #section{id=dropdowns, body=[
              #panel{class=["page-header", "docs-header"], body=#h2{body= [<<"Drop Downs">>, #small{body= <<"some drop downs">>}]}},
              #p{body= <<"Laudantium ut saepe dolor qui sint cupiditate et eaque voluptatibus in. dolorum ratione reiciendis itaque unde quo quam. distinctio et ut dolorem iste perspiciatis odit magni aperiam rem consequatur ea non et vero">>},
              #p{body= <<"Fugit reprehenderit qui perferendis aut distinctio repellendus error sequi et. nobis cumque tempore perspiciatis inventore sit consectetur dolorum eos perferendis et sed quis aut. accusamus nulla harum architecto eius at ipsa non vel voluptatem consequatur recusandae. quod aspernatur veniam qui sapiente cum inventore repudiandae dolorem ducimus fuga amet officiis. nisi est eos aut sed sit quo sit deleniti voluptas">>},
              #p{body= <<"Et cupiditate quia in ut aut beatae maxime est cupiditate aliquam fugit. voluptatem id et eos illo qui magnam excepturi architecto. iusto ipsam magnam quia culpa blanditiis officiis nulla. est nobis sed et qui adipisci labore nihil porro. sit quod sed est minus est molestiae placeat. repellendus voluptatem molestiae ut aut voluptatem est ut veniam suscipit aliquam voluptas praesentium">>}
            ]},
            #section{id="end", body= [
              #panel{class=["page-header", "docs-header"], body= #h2{body=[ <<"The end">>, #small{ body= <<"some last words">>}]}},
              #p{body= <<"Totam magni commodi perferendis quas explicabo aspernatur debitis iste dolore eum omnis et exercitationem. eligendi sequi totam et est optio. sint quis eos fugiat et tenetur velit corrupti veniam consequatur expedita eligendi blanditiis sit. harum in a vel delectus dolorem ut et odit dolorem molestiae eaque enim velit adipisci. nam pariatur et possimus velit accusantium libero impedit nihil quas repellat animi voluptas">>},
              #p{body= <<"Consectetur quis et consequatur minima libero omnis quos. saepe distinctio accusamus in debitis architecto voluptatem mollitia deserunt corporis et. ut rerum consectetur quos magni cum laborum repudiandae iusto qui incidunt. tempora non dolor dolorem exercitationem quia">>}
            ]}
          ]}
        ]}
      }
    }
  }
  ] ++ index:footer().

sidebar_menu(Page)->
  Lis = [#li{class=if Page==I->active;true->[]end, body=#link{url="#"++atom_to_list(I), body=T}}
    || {I, T} <- [{boxes, <<"boxes">>}, {releases, <<"releases">>}, {apps, <<"apps">>}, {ssh, <<"ssh">>}, {account, <<"account">>}]],
  #panel{class=["docs-sidebar-menu", "dash-sidebar-menu"], body=#list{class=[nav, "nav-list", "docs-sidebar-nav", "dash-sidebar-nav", "affix-top"],
    data_fields=[{<<"data-spy">>, <<"affix">>}],
    body=Lis}}.

section(Body, Icon) ->
  #section{class=["row-fluid", "dashboard-section"], body=[
    #panel{class=[span1], body=#i{class=[Icon, "icon-2x"]}},
    #panel{class=[span11, "dashboard-unit"], body=Body}
  ]}.

api_event(Name,Tag,Term) -> error_logger:info_msg("dashboard Name ~p, Tag ~p, Term ~p",[Name,Tag,Term]).
event(init) -> [].
