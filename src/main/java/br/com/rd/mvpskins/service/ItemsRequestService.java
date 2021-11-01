package br.com.rd.mvpskins.service;

import br.com.rd.mvpskins.model.dto.ItemsRequestCompositeKeyDTO;
import br.com.rd.mvpskins.model.dto.ItemsRequestDTO;
import br.com.rd.mvpskins.model.dto.RequestDTO;
import br.com.rd.mvpskins.model.embeddable.ItemsRequestCompositeKey;
import br.com.rd.mvpskins.model.entity.ItemsRequest;
import br.com.rd.mvpskins.model.entity.Request;
import br.com.rd.mvpskins.repository.contract.ItemsRequestRepository;
import br.com.rd.mvpskins.repository.contract.RequestRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
public class ItemsRequestService {

    @Autowired
    ItemsRequestRepository itemsRequestRepository;

    @Autowired
    RequestService requestService;

    @Autowired
    RequestRepository requestRepository;

    //  ---------------------> CONVERTER PARA BUSINESS
    private ItemsRequest dtoToBusiness (ItemsRequestDTO dto) {

        //        ===> REQUEST
        ItemsRequestCompositeKey id = new ItemsRequestCompositeKey();
        if (dto.getId().getRequest() != null) {
            Request r = requestRepository.getById(dto.getId().getRequest().getId());

            id.setIdProduct(dto.getId().getIdProduct());
            id.setRequest(r);
        }

        ItemsRequest b = new ItemsRequest();
        b.setId(id);
        b.setQuantity(dto.getQuantity());
        b.setDiscount(dto.getDiscount());
        b.setGrossAddedValue(dto.getGrossAddedValue());
        b.setNetValue(dto.getNetValue());

        return b;
    }

    //  ---------------------> CONVERTER PARA DTO
    private ItemsRequestDTO businessToDTO (ItemsRequest b) {
//        Request request = nfRepository.getById(b.getId().getIdProduct());

        //        ===> REQUEST
        ItemsRequestCompositeKeyDTO id = new ItemsRequestCompositeKeyDTO();
        if (b.getId().getRequest() != null) {
            RequestDTO r = requestService.searchID(b.getId().getRequest().getId());

            id.setIdProduct(b.getId().getIdProduct());
            id.setRequest(r);
        }

        ItemsRequestDTO dto = new ItemsRequestDTO();
        dto.setId(id);
        dto.setQuantity(b.getQuantity());
        dto.setDiscount(b.getDiscount());
        dto.setGrossAddedValue(b.getGrossAddedValue());
        dto.setNetValue(b.getNetValue());

        return dto;
    }

    //  ---------------------> CONVERTER LISTA BUSINESS PARA LISTA DTO
    private List<ItemsRequestDTO> listToDTO (List<ItemsRequest> listB) {
        List<ItemsRequestDTO> listDTO = new ArrayList<>();

        for (ItemsRequest b : listB) {
            listDTO.add(this.businessToDTO(b));
        }

        return listDTO;
    }

    //  ---------------------> CRIAR
    public ItemsRequestDTO create (ItemsRequestDTO itemsRequestDTO) {

            ItemsRequest itemsRequest = dtoToBusiness(itemsRequestDTO);
            itemsRequest = itemsRequestRepository.save(itemsRequest);

            return businessToDTO(itemsRequest);
    }


    //  ---------------------> BUSCAR
    //TODOS OS ITENS DE PEDIDOS
    public List<ItemsRequestDTO> searchAll() {
        List<ItemsRequest> list = itemsRequestRepository.findAll();

        return listToDTO(list);
    }

    //UM ITEM DE PEDIDO POR ID
    public ItemsRequestDTO searchID(Long idProduct, Long idRequest) {

        if (requestRepository.existsById(idRequest)) {
            ItemsRequestCompositeKey id = new ItemsRequestCompositeKey();
            id.setIdProduct(idProduct);
            id.setRequest(requestRepository.getById(idRequest));

            if (itemsRequestRepository.existsById(id)) {
                return businessToDTO(itemsRequestRepository.getById(id));
            }
        }

        return null;
    }

    //  ---------------------> ATUALIZAR
    public ItemsRequestDTO update(ItemsRequestDTO dto, Long idProduct, Long idRequest) {

        if (requestRepository.existsById(idRequest)) {
            ItemsRequestCompositeKeyDTO id = new ItemsRequestCompositeKeyDTO();
            id.setIdProduct(idProduct);
            id.setRequest(requestService.searchID(idRequest));
            dto.setId(id);

            ItemsRequest itemsRequest = dtoToBusiness(dto);
            Optional<ItemsRequest> opt = itemsRequestRepository.findById(itemsRequest.getId());

            if (opt.isPresent()) {
                ItemsRequest update = opt.get();

                if (itemsRequest.getQuantity() != null) {
                    update.setQuantity(itemsRequest.getQuantity());
                }

                if (itemsRequest.getDiscount() != null) {
                    update.setDiscount(itemsRequest.getDiscount());
                }

                if (itemsRequest.getGrossAddedValue() != null) {
                    update.setGrossAddedValue(itemsRequest.getGrossAddedValue());
                }

                if (itemsRequest.getNetValue() != null) {
                    update.setNetValue(itemsRequest.getNetValue());
                }

                itemsRequestRepository.save(update);
                return businessToDTO(update);
            }
        }

        return null;
    }

    //  ---------------------> DELETAR
    public void delete(Long idProduct, Long idRequest) {
        ItemsRequestCompositeKey id = new ItemsRequestCompositeKey();
        id.setIdProduct(idProduct);
        id.setRequest(requestRepository.getById(idRequest));

        if (itemsRequestRepository.existsById(id)) {
            itemsRequestRepository.deleteById(id);
        }
    }
}