NAME		:=	jbastard
COMPOSE		:=	./srcs/docker-compose.yml
DATA_DIR	:=	/home/jbastard/data
ENV_FILE	:=	--env-file ./srcs/.env

all: $(NAME)

$(NAME):
	@mkdir -p $(DATA_DIR)/wordpress $(DATA_DIR)/mysql
	@docker-compose $(ENV_FILE) -f $(COMPOSE) up -d --build

down:
	@docker-compose $(ENV_FILE) -f $(COMPOSE) down

clean:
	@docker-compose $(ENV_FILE) -f $(COMPOSE) down -v

fclean: clean
	@docker system prune --force --volumes --all
	@sudo rm -rf $(DATA_DIR)

re: down all

logs:
	@docker-compose $(ENV_FILE) -f $(COMPOSE) logs

.PHONY: all down clean fclean re logs
